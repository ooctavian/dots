{ config, pkgs, ... }:
{
imports = [
  ./neovim.nix 
   # ./zsh.nix
  # ./fish.nix
  # ./tmux.nix
  ./firefox.nix
  ./dunst.nix
  ./eclipse.nix
];

# RANGER
home.file.".config/ranger/rc.conf".text = ''
set preview_images true
set preview_images_method ueberzug
'';

# mpv 
 programs.mpv = {
        enable = true;
        bindings = {
          WHEEL_UP = "add volume 5";
          WHEEL_DOWN = "add volume -5";
          WHEEL_LEFT = "seek -3";
          WHEEL_RIGHT = "seek 3";
          h = "seek -3";
          l = "seek 3";
        };
      };
 # gtk = {
 #   enable = true;
 #    theme = let
 #        phocus = pkgs.stdenv.mkDerivation {
 #          name = "phocus";
 #          src = builtins.fetchTarball https://github.com/elkowar/gtk/archive/master.tar.gz;
 #          nativeBuildInputs = [ pkgs.sass ];
 #          installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
 #        };
 #      in {
 #      package = phocus;
 #      name = "phocus";
 #    };
 #   iconTheme = {
 #     package = pkgs.arc-icon-theme;
 #     name = "Arc-X-D";
 # };
 # };
}
