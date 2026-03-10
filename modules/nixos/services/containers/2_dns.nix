{ staticIP, ... }:
{
  containers.dns = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.1.1.1";
    localAddress = "10.1.1.2";

    forwardPorts = [
      {
        protocol = "tcp";
        hostPort = 53;
        containerPort = 53;
      }
      {
        protocol = "udp";
        hostPort = 53;
        containerPort = 53;
      }

      # backup ui
      {
        protocol = "tcp";
        hostPort = 3000;
        containerPort = 3000;
      }
    ];

    config =
      { config, pkgs, ... }:
      {
        services.adguardhome = {
          enable = true;

          mutableSettings = false;
          settings = {
            users = [
              {
                name = "admin";
                password = "$2y$10$X5mC73Amnv/z7yR6GinKMOOTd7XyZnfZXNNGSaDQl4Sl3xFFkjl4u";
              }
            ];

            dns = {
              bind_hosts = [ "0.0.0.0" ];
              port = 53;

              upstream_mode = "fastest_addr";
              upstream_dns = [
                "1.1.1.1"
                "8.8.8.8"
                "9.9.9.9"
              ];

              bootstrap_dns = [
                "1.1.1.1"
                "8.8.8.8"
                "9.9.9.9"
              ];

              cache_size = 4194304;
              cache_ttl_min = 3600;
              cache_ttl_max = 86400;
            };

            filtering = {
              rewrites = [
                {
                  enabled = true;
                  domain = "home.lan";
                  answer = "${staticIP}";
                }
                {
                  enabled = true;
                  domain = "*.home.lan";
                  answer = "${staticIP}";
                }
                {
                  enabled = true;
                  domain = "*.home.lan.fritz.box";
                  answer = "${staticIP}";
                }
              ];
            };
          };
        };

        networking.firewall.allowedTCPPorts = [
          53
          3000
        ];
        networking.firewall.allowedUDPPorts = [ 53 ];
        system.stateVersion = "25.11";
      };
  };
}
