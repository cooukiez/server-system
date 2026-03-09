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

  # networking configuration
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "eth0";
  };

  services.caddy = {
    enable = true;

    globalConfig = ''
      auto_https emits_redirects
    '';

    virtualHosts."home.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        header Strict-Transport-Security "max-age=31536000; includeSubDomains"
        reverse_proxy 10.1.1.2:8000
      '';
    };

    virtualHosts."glances.home.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        header Strict-Transport-Security "max-age=31536000; includeSubDomains"
        reverse_proxy 10.1.1.3:8000
      '';
    };

    virtualHosts."paperless.home.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        header Strict-Transport-Security "max-age=31536000; includeSubDomains"
        reverse_proxy 10.1.1.4:8000
      '';
    };

    virtualHosts."jupyter.home.lan" = {
      useACMEHost = null;
      extraConfig = ''
        tls internal
        header Strict-Transport-Security "max-age=31536000; includeSubDomains"
        reverse_proxy 10.1.1.5:8000
      '';
    };
  };

  networking.hosts = {
    staticIP = [ "home.lan" ];
  };
}
