/*
  modules/nixos/services/open-ssh.nix

  part of der-home-server
  created 2026-02-21
*/

{
  services.openssh = {
    enable = true;
    settings = {
      # opinionated: forbid root login through SSH
      PermitRootLogin = "no";
      # opinionated: keys and passwords
      PasswordAuthentication = true;
    };
  };
}
