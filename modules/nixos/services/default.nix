/*
  modules/nixos/services/default.nix

  part of der-home-server
  created 2026-02-21
*/

{
  staticIP,
  ...
}:
{
  imports = [
    ./copyparty.nix
    ./open-ssh.nix
    ./stalwart.nix
  ];

  # enable firmware update services
  services.fwupd.enable = true;
  # enable devmon for device management
  services.devmon.enable = true;
  # network statistics
  services.vnstat.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      UseDns = true;
      X11Forwarding = false;

      # opinionated: forbid root login through SSH
      PermitRootLogin = "no";
      # opinionated: keys and passwords
      PasswordAuthentication = true;
    };
  };

  services.glances = {
    enable = true;
    # ensure it listens to subnet IP
    extraArgs = [
      "-w"
      "-B"
      "${staticIP}"
    ];
  };
}
