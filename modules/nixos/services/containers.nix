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
          settings = {
            layout = {

            };
          };
        };

        networking.firewall.allowedTCPPorts = [ 3000 ];
        system.stateVersion = "25.11";
      };
  };

  services.caddy = {
    enable = true;
    virtualHosts."homepage.server" = {
      extraConfig = ''
        reverse_proxy 10.1.1.2:3000
      '';
    };
  };

  networking.hosts = {
    "127.0.0.1" = [ "homepage.server" ];
  };
}
