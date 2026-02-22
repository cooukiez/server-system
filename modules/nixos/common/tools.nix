/*
  modules/nixos/common/tools.nix

  part of der-home-server
  created 2026-02-21
*/

{
  pkgs,
  ...
}:
let
  fix-perms = pkgs.writeShellScriptBin "fix-perms" (builtins.readFile ./scripts/fix-perms.sh);
in
{
  # nvim base editor
  programs.neovim.enable = true;

  environment.systemPackages = with pkgs; [
    # cli tools, sorted alphabetically
    aria2
    bandwhich
    bench
    btop
    ctop
    dfc
    dua
    fix-perms
    glances
    gping
    htop
    httpie
    lazydocker
    lazygit
    ngrok
    procs
    ripgrep
    speedtest-cli
    transfer-sh
  ];
}
