{
  pkgs,
  ...
}:
let
  # unsafe password
  copyparty_pm_password = pkgs.writeText "copyparty-pm-password" ''
    fileupload123
  '';
in
{
  # copyparty, fast file sharing server
  services.copyparty = {
    enable = true;
    user = "copyparty";
    group = "copyparty";

    settings.i = "0.0.0.0";
    settings.p = 3923;
    settings.no-reload = true;

    accounts = {
      pm = {
        passwordFile = "${copyparty_pm_password}";
      };
    };

    groups = {
      pg = [ "pm" ];
    };

    volumes = {
      "/" = {
        path = "/data/copyparty";

        # see `copyparty --help-accounts`
        access = {
          # everyone gets read access
          r = "*";
          # users here get write access
          rw = [ "pm" ];
        };

        # see `copyparty --help-flags`
        flags = {
          # "fk" enables filekeys (necessary for upget permission) (4 chars long)
          fk = 4;
          # scan for new files every 60sec
          scan = 60;
          # volflag "e2d" enables the uploads database
          e2d = true;
          # "d2t" disables multimedia parsers (in case the uploads are malicious)
          d2t = true;
          # skips hashing file contents if path matches *.iso
          nohash = "\.iso$";
        };
      };
    };

    openFilesLimit = 8192;
  };

}
