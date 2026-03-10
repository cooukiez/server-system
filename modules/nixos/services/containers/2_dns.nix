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
    ];

    config =
      { config, pkgs, ... }:
      {
        services.adguardhome = {
          enable = true;

          settings = {
            dns = {
              bind_hosts = [ "0.0.0.0" ];
              port = 53;

              upstream_dns = [
                "1.1.1.1"
                "9.9.9.9"
              ];

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
