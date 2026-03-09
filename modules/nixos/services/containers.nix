{
  lib,
  staticIP,
  ...
}:
{
  imports = [
    ./containers/2_homepage.nix
    ./containers/3_glances.nix
    ./containers/4_paperless.nix
    ./containers/5_jupyter.nix
  ];

  boot.enableContainers = true;
  virtualisation.containers.enable = true;

  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "eth0";
  };

  services.caddy = {
    enable = true;
    virtualHosts."home.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        reverse_proxy 10.1.1.2:3000
      '';
    };

    virtualHosts."paperless.home.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        reverse_proxy 10.1.1.4:28981
      '';
    };

    virtualHosts."jupyter.home.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        reverse_proxy 10.1.1.5:8888
      '';
    };

    virtualHosts."glances.home.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        reverse_proxy 10.1.1.3:61208
      '';
    };
  };

  networking.hosts = {
    staticIP = [ "home.lan" ];
  };
}
