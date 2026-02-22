/*
  modules/nixos/dashboard/default.nix

  part of der-home-server
  created 2026-02-22
*/

{
  staticIP,
  ...
}:
{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082;

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

    # logos: https://github.com/homarr-labs/dashboard-icons.git
    # icons: https://pictogrammers.com/library/mdi/

    services = [
      {
        "System Monitor" = [
          {
            "CPU Usage" = {
              widget = {
                type = "glances";
                url = "http://${staticIP}:61208";
                version = 4;
                metric = "cpu";
              };
            };
          }
          {
            "Memory Usage" = {
              widget = {
                type = "glances";
                url = "http://${staticIP}:61208";
                version = 4;
                metric = "memory";
              };
            };
          }
          {
            "Network Usage" = {
              widget = {
                type = "glances";
                url = "http://${staticIP}:61208";
                version = 4;
                metric = "network:eth0";
              };
            };
          }
          {
            "Disk I/O" = {
              widget = {
                type = "glances";
                url = "http://${staticIP}:61208";
                version = 4;
                metric = "disk:sda";
              };
            };
          }
        ];
      }
    ];

    settings = {
      title = "homeserver";
      headerStyle = "clean";
      layout = {
        "System Monitor" = {
          style = "row";
          columns = 4;
        };
        "File Transfer" = {
          style = "row";
          columns = 4;
        };
      };
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."${staticIP}" = {
      default = true;
      serverAliases = [
        "127.0.0.1"
        "localhost"
        "lvl"
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:8082";
        proxyWebsockets = true;
      };
    };
  };
}
