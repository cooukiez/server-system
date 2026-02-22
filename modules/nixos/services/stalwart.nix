{
  config,
  pkgs,
  hostname,
  staticIP,
  ...
}:
{
  age.secrets.stalwart-admin-pw = {
    file = ../../../secrets/stalwart-admin.age;
    owner = "stalwart-mail";
    group = "stalwart-mail";
  };

  age.secrets.stalwart-ludwig-pw = {
    file = ../../../secrets/stalwart-ludwig.age;
    owner = "stalwart-mail";
    group = "stalwart-mail";
  };

  services.stalwart-mail = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        hostname = hostname;
        # Set to true if you manage certs via ACME/Caddy
        tls.enable = false;

        listener = {
          # dav & management listeners
          jmap = {
            bind = [ "${staticIP}:8080" ];
            url = "http://${staticIP}:8080";
            protocol = "http";
          };

          management = {
            bind = [ "${staticIP}:9080" ];
            protocol = "http";
          };
        };
      };

      # enable the DAV modules
      jmap.enabled = true;
      caldav.enabled = true;
      carddav.enabled = true;

      directory."in-memory" = {
        type = "memory";
        principals = [
          {
            class = "individual";
            name = "Ludwig";
            secret = "%{file:${config.age.secrets.stalwart-ludwig-pw.path}}%";
            email = [ "ludwig.geyer@mailbox.org" ];
          }
        ];
      };

      storage.directory = "in-memory";
      session.auth.directory = "'in-memory'";

      authentication.fallback-admin = {
        user = "admin";
        secret = config.age.secrets.stalwart-admin-pw.path;
      };
    };
  };
}
