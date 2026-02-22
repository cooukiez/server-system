{
  config,
  pkgs,
  hostname,
  staticIP,
  ...
}:
{
  age.secrets.stalwart-pw = {
    file = ../../../secrets/stalwart-admin.age;
    owner = "stalwart-mail";
  };

  services.stalwart-mail = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        hostname = hostname;
        tls.enable = false; # Set to true if you manage certs via ACME/Caddy

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
            name = "Home User";
            secret = "foobar123"; # Or use %{file:/etc/stalwart/user-pw}%
            email = [ "user@example.local" ];
          }
        ];
      };

      storage.directory = "in-memory";
      session.auth.directory = "'in-memory'";

      authentication.fallback-admin = {
        user = "admin";
        secret = "%{file:${config.age.secrets.stalwart-pw.path}}%";
      };
    };
  };
}
