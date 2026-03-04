{
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "home-server";
        email = "ludwig-geyer@web.de";
      };

      advice.defaultBranchName = false;

      safe = {
        directory = [
          "/etc/nixos"
        ];
      };
    };
  };
}
