{ pkgs }:
{
  allowUnfree = true;
  overlays = [ (import ./packages/overlay.nix) ];
}
