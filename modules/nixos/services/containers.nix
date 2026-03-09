{
  lib,
  staticIP,
  ...
}:
{
  boot.enableContainers = true;
  virtualisation.containers.enable = true;

  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "eth0";
  };

  containers.homepage = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.1.1.1";
    localAddress = "10.1.1.2";

    config =
      { config, pkgs, ... }:
      {
        services.homepage-dashboard = {
          enable = true;
          listenPort = 3000;

          widgets = [
            {
              greeting = {
                text = "My Laptop";
                help = true;
              };
            }
            {
              datetime = {
                format = {
                  date = "long";
                  time = "short";
                  hour12 = false;
                };
              };
            }
            {
              openmeteo = {
                label = "Weather";

                # location: berlin
                latitude = "52.52";
                longitude = "13.40";

                units = "metric";
                cache = 5;
              };
            }
          ];

          services = [
            {
              "System Monitor" = [
                {
                  "CPU Usage" = {
                    widget = {
                      type = "glances";
                      url = "http://10.1.1.3:61208";
                      version = 4;
                      metric = "cpu";
                    };
                  };
                }
                {
                  "Memory Usage" = {
                    widget = {
                      type = "glances";
                      url = "http://10.1.1.3:61208";
                      version = 4;
                      metric = "memory";
                    };
                  };
                }
                {
                  "Network Usage" = {
                    widget = {
                      type = "glances";
                      url = "http://10.1.1.3:61208";
                      version = 4;
                      metric = "network:eth0";
                    };
                  };
                }
                {
                  "Disk I/O" = {
                    widget = {
                      type = "glances";
                      url = "http://10.1.1.3:61208";
                      version = 4;
                      metric = "disk:sda1";
                    };
                  };
                }
              ];
            }
          ];

          settings = {
            title = "homeserver";
            headerStyle = "clean";
            background = "/background.png";

            layout = {
              "System Monitor" = {
                style = "row";
                columns = 4;
              };
              "File Management" = {
                style = "row";
                columns = 4;
              };
              "Network Storage" = {
                style = "row";
                columns = 4;
              };
            };
          };
        };

        systemd.services.homepage-dashboard.environment = {
          HOMEPAGE_ALLOWED_HOSTS = lib.mkForce "homepage.lan,${staticIP}";
        };

        networking.firewall.allowedTCPPorts = [ 3000 ];
        system.stateVersion = "25.11";
      };
  };

  containers.glances = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.1.1.1";
    localAddress = "10.1.1.3";

    config =
      { config, pkgs, ... }:
      {
        services.glances = {
          enable = true;
          extraArgs = [
            "-w"
            "-B"
            "0.0.0.0"
          ];
        };

        networking.firewall.allowedTCPPorts = [ 61208 ];
        system.stateVersion = "25.11";
      };
  };

  containers.paperless = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.1.1.1";
    localAddress = "10.1.1.4";

    config =
      { config, pkgs, ... }:
      {
        environment.etc."paperless-admin-pass".text = "admin";

        services.paperless = {
          enable = true;
          passwordFile = "/etc/paperless-admin-pass";

          port = 28981;
          address = "0.0.0.0";

          settings = {
            PAPERLESS_TIME_ZONE = "Europe/Berlin";

            PAPERLESS_ALLOWED_HOSTS = "homepage.lan,${staticIP},10.1.1.4";
            PAPERLESS_CSRF_TRUSTED_ORIGINS = "https://homepage.lan";
          };
        };

        networking.firewall.allowedTCPPorts = [ 28981 ];
        system.stateVersion = "25.11";
      };
  };

  services.caddy = {
    enable = true;
    virtualHosts."homepage.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        reverse_proxy 10.1.1.2:3000
      '';
    };

    virtualHosts."homepage.lan:8000" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        reverse_proxy 10.1.1.4:28981
      '';
    };

    virtualHosts."homepage.lan:61208" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        reverse_proxy 10.1.1.3:61208
      '';
    };
  };

  security.pki.certificates = [
    (builtins.readFile ./caddy-root.crt)
  ];

  networking.hosts = {
    staticIP = [ "homepage.lan" ];
  };
}
