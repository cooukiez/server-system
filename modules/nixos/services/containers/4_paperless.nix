{
  staticIP,
  ...
}:
{
  containers.paperless = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.1.1.1";
    localAddress = "10.1.1.4";

    config =
      { config, pkgs, ... }:
      {
        environment.etc."paperless-admin-pass".text = "admin";

        services.paperless = {
          enable = true;
          passwordFile = "/etc/paperless-admin-pass";

          port = 8000;
          address = "0.0.0.0";

          settings = {
            PAPERLESS_OCR_LANGUAGE = "deu+eng";
            PAPERLESS_TIME_ZONE = "Europe/Berlin";

            PAPERLESS_CSRF_TRUSTED_ORIGINS = "https://home.lan:8000,https://${staticIP}:8000";
            PAPERLESS_URL = "https://home.lan:8000";
          };
        };

        networking.firewall.allowedTCPPorts = [ 8000 ];
        system.stateVersion = "25.11";
      };
  };
}
