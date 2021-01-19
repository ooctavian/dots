{ config, pkgs, ... }:
{
  programs.eclipse = {
    enable = true;
    package = pkgs.eclipses.eclipse-java;
    enableLombok = true;
  };
}
