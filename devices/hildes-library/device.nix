{ flake-utils, nixpkgs, ... }:
let
  inherit (flake-utils.lib.system) x86_64-linux;
in
{
  username = "emma";
  displayName = "Emma";
  hostname = "hildes-library";
  nixOS.stateVersion = "26.05";
  platform = nixpkgs.lib.systems.elaborate x86_64-linux;
  home-manager.stateVersion = "26.05";
}
