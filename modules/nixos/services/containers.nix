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

  services.caddy = {
    enable = true;
    virtualHosts."homepage.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        reverse_proxy 10.1.1.2:3000
      '';
    };

    virtualHosts."homepage.lan:61208" = {
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
