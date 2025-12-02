{
  inputs,
  lib,
  pkgs,
  device-conf,
  ...
}:
let
  inherit (inputs) mac-app-util;
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
  inherit (device-conf) username;
in
mkIf isDarwin {
  home-manager.users.${username}.targets.darwin = {
    copyApps.enable = true;
    linkApps.enable = false;
  };

  ## Disable for now because sbcl is broken
  # home-manager.sharedModules = [
  #   mac-app-util.homeManagerModules.default
  # ];
}
