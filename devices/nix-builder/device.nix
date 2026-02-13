{ flake-utils, nixpkgs, ... }:
let
  inherit (flake-utils.lib.system) x86_64-linux aarch64-linux;
in
{
  username = "warren";
  displayName = "Warren";
  hostname = "nix-builder";
  nixOS.stateVersion = "25.11";
  platform = nixpkgs.lib.systems.elaborate x86_64-linux;
  home-manager.stateVersion = "25.11";
}
