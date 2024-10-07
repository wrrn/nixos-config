{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (inputs) mac-app-util;
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;

in
mkIf isDarwin {
  home-manager.sharedModules = [
    mac-app-util.homeManagerModules.default
  ];
}
