{
  inputs,
  pkgs,
  lib,
  hostSystem,
  ...
}:
{
  imports = [
    ./tools.nix
  ];

  services.dbus.enable = true;

  # common container config
  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };

    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.sessionVariables = {
    # set LIBVA_DRIVER_NAME environment variable for video acceleration
    # LIBVA_DRIVER_NAME = "iHD";
  };

  programs.nix-ld.enable = true;

  # zsh shell
  programs.zsh.enable = true;

  # system packages
  environment.systemPackages = with pkgs; [
    # core packages, sorted alphabetically
    age
    cifs-utils
    clang
    cmake
    coreutils
    cpuid
    curl
    diffutils
    dmidecode
    exfatprogs
    exiftool
    fastfetch
    fdupes
    fzf
    gcc
    gdb
    git
    glib
    gnumake
    gnutar
    inetutils
    jq
    killall
    lsof
    mesa
    mtools
    ntfsprogs
    openssl
    parted
    rclone
    rsync
    rustup
    sd
    tmux
    toybox
    tree
    unixtools.quota
    unzip
    wget
    zip

    # encryption
    inputs.agenix.packages.${hostSystem}.default

    # nixos related
    home-manager
    nixfmt-rfc-style
    nixfmt-tree
    nix-prefetch-git
    nix-search
  ];
}
