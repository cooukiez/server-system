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

              upstream_dns = [
                "1.1.1.1"
                "9.9.9.9"
              ];

              rewrites = [
                {
                  domain = "home.lan";
                  answer = "${staticIP}";
                }
                {
                  domain = "*.home.lan";
                  answer = "${staticIP}";
                }
                {
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
