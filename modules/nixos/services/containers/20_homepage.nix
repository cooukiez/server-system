{
  lib,
  staticIP,
  ...
}:
{

  containers.homepage = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.1.1.1";
    localAddress = "10.1.1.20";

    config =
      { config, pkgs, ... }:
      {
        services.homepage-dashboard = {
          enable = true;
          listenPort = 8000;

          widgets = [
            {
              greeting = {
                text = "Homeserver";
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
                      url = "http://10.1.1.21:8000";
                      version = 4;
                      metric = "cpu";
                    };
                  };
                }
                {
                  "Memory Usage" = {
                    widget = {
                      type = "glances";
                      url = "http://10.1.1.21:8000";
                      version = 4;
                      metric = "memory";
                    };
                  };
                }
                {
                  "Network Usage" = {
                    widget = {
                      type = "glances";
                      url = "http://10.1.1.21:8000";
                      version = 4;
                      metric = "network:eth0";
                    };
                  };
                }
                {
                  "Disk I/O" = {
                    widget = {
                      type = "glances";
                      url = "http://10.1.1.21:8000";
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
          HOMEPAGE_ALLOWED_HOSTS = lib.mkForce "home.lan,${staticIP}";
        };

        networking.firewall.allowedTCPPorts = [ 8000 ];
        system.stateVersion = "25.11";
      };
  };
}
