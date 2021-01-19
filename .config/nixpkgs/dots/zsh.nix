{ config, pkgs, ...}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    autocd = true;
    history = {
      extended = true;
      ignoreDups = true;
      path = "$HOME/.cache/zsh_history";
      save = 1000000;
      share = true;
      size = 1000000;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
      theme = "robbyrussell";
    };
  };
 programs.zsh.shellAliases = {
    "ll" = "ls -l";
    ".." = "cd ..";
    "hb" = "home-builder switch";
    "build_root" = "sudo nixos-rebuild switch";
    "delete_gens" = "nix-env -p /nix/var/nix/profiles/system --delete-generations old";
    "list_gens" = "nix-env -p /nix/var/nix/profiles/system --list-generations";
    "cdh" = "cd $HOME";
  };

}
