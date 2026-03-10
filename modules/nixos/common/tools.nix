/*
  modules/nixos/common/tools.nix

  part of der-home-server
  created 2026-02-23
*/

{
  pkgs,
  ...
}:
let
  fix-perms = pkgs.writeShellScriptBin "fix-perms" (builtins.readFile ./scripts/fix-perms.sh);
  sync-flake = pkgs.writeShellScriptBin "sync-flake" (builtins.readFile ./scripts/sync-flake.sh);
in
{
  # nvim base editor
  programs.neovim.enable = true;

  environment.systemPackages = with pkgs; [
    # cli tools, sorted alphabetically
    aria2
    apacheHttpd
    bandwhich
    bench
    btop
    ctop
    dfc
    dig
    dua
    fix-perms
    gping
    htop
    httpie
    lazydocker
    lazygit
    ngrok
    powertop
    procs
    sync-flake
    ripgrep
    speedtest-cli
    transfer-sh
  ];
}
