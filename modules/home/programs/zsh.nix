/*
  modules/home/programs/zsh.nix

  part of der-home-server
  created 2026-02-23
*/

{
  userConfig,
  hostname,
  ...
}:
{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -la";
      gs = "git status";

      us = "pull-flake && sudo nixos-rebuild switch --upgrade-all --no-write-lock-file";
      uh = "pull-flake && home-manager switch --flake /etc/nixos#${userConfig.name}@${hostname} --no-write-lock-file";

      nus = "pull-flake && nh os switch /etc/nixos#nixosConfigurations.${hostname} --update --no-write-lock-file";
      nuh = "pull-flake && nh home switch /etc/nixos#homeConfigurations.${userConfig.name}@${hostname}.activationPackage --no-write-lock-file";
      nuuh = "pull-flake && nh home switch /etc/nixos#homeConfigurations.${userConfig.name}@${hostname}.activationPackage --update --no-write-lock-file";

      cns = "sudo sh -c 'nix-env -p /nix/var/nix/profiles/system --delete-generations old && nix-collect-garbage -d && nix-store --optimise && nix-store --verify --check-contents --repair'";
      cnh = "nix-env --delete-generations old && nix profile wipe-history && home-manager expire-generations \"-0 seconds\" && nix-collect-garbage -d";

      nd = "cd /etc/nixos";

      gtop = "sudo intel_gpu_top";

      help = "bash -c 'help'";

      c = "clear";
    };

    initContent = ''
      bindkey -e
      export EDITOR=nvim

      # enable colors
      autoload -U colors && colors

      # set prompt style
      PROMPT='%F{green}%n%F{yellow}@%m%f:%~$ '
    '';

    history.size = 16384;
  };
}
