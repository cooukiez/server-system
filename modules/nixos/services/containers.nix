{
  lib,
  staticIP,
  ...
}:
{
  imports = [
    ./containers/2_dns.nix

    ./containers/20_homepage.nix
    ./containers/21_glances.nix

    ./containers/101_paperless.nix
    ./containers/102_jupyter.nix
  ];

  boot.enableContainers = true;
  virtualisation.containers.enable = true;

  # networking configuration
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
        header Strict-Transport-Security "max-age=31536000; includeSubDomains"
        reverse_proxy 10.1.1.20:8000
      '';
    };

    virtualHosts."glances.home.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        header Strict-Transport-Security "max-age=31536000; includeSubDomains"
        reverse_proxy 10.1.1.21:8000
      '';
    };

    virtualHosts."jupyter.home.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        header Strict-Transport-Security "max-age=31536000; includeSubDomains"
        reverse_proxy 10.1.1.101:8000
      '';
    };

    virtualHosts."paperless.home.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        header Strict-Transport-Security "max-age=31536000; includeSubDomains"
        reverse_proxy 10.1.1.102:8000
      '';
    };
  };

  networking.hosts = {
    staticIP = [ "home.lan" ];
  };
}
