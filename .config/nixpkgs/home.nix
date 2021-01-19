{ config, pkgs, ... }:
let 
  user = builtins.getEnv "USER";
  homedir = builtins.getEnv "HOME";
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = user;
  home.homeDirectory = homedir;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
  home.language.base = "en-US.UTF-8";

  # Nix config
    nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
    overlays = [ (import ./packages/overlay.nix) ];

  };

fonts.fontconfig.enable= true;

imports = [
./dots
];
home.packages = with pkgs;[
  nix-prefetch-github
  xclip
  st-custom
  htop
  pcmanfm
  glibcLocales
  dina-font
  lxappearance
  ueberzug
  boox
  shotgun
  hsetroot
  xcompmgr
  xfce.thunar
  xfce.thunar-volman
  xdg-user-dirs
  ibm-plex
  fira-code
  dunst
  lemonbar-xft
  ranger
  jdk14
  jre
  maven
  viewnior
  ];

  home.sessionVariables = {
    LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    LOCALE_ARCHIVE_2_27 = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    BROWSER = "firefox";
  };
 programs.git = {
 enable = true;
 userName = "Virgin Führer";
 userEmail = "octaviancir@gmail.com";
 };
 home.file.".profile".text = ''
    # -*- mode: sh -*-
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
     export PATH="$HOME/.local/bin:$PATH"
     export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.share:/usr/local/share/:/usr/share/"
     export XMONAD_CONFIG_HOME="$HOME/.config/xmonad"
     export XMONAD_DATA_HOME="$HOME/.config/xmonad/"
     export XMONAD_CACHE_HOME="$HOME/.config/xmonad/"
'';
}

