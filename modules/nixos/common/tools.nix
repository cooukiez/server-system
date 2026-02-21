{
  pkgs,
  ...
}:
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
