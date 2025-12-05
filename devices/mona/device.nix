{ flake-utils, nixpkgs, ... }:
let
  inherit (flake-utils.lib.system) aarch64-darwin;
in
{
  username = "warren";
  displayName = "Warren";
  hostname = "mona";
  platform = nixpkgs.lib.systems.elaborate aarch64-darwin;
  nixOS.stateVersion = 6;
  home-manager.stateVersion = "25.11";
}
