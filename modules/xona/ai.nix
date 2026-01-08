{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (inputs) wrrnpkgs;
in
{
  nixpkgs.overlays = [
    wrrnpkgs.overlays.default
  ];
  home-manager.users.${username}.home.packages = [
    pkgs.wrrn.codex
  ];
}
