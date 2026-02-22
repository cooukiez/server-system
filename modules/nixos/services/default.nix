/*
  modules/nixos/services/default.nix

  part of der-home-server
  created 2026-02-21
*/

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
}
