{ flake-utils, nixpkgs, ... }:
let
  inherit (flake-utils.lib.system) x86_64-linux aarch64-linux;
in
{
  username = "warren";
  displayName = "Warren";
  hostname = "lona";
  nixOS.stateVersion = "25.11";
  platform = nixpkgs.lib.systems.elaborate x86_64-linux; # TODO: Change for laptop
  home-manager.stateVersion = "26.05";
}
