{
  options,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) optionalAttrs mkIf;
in
mkIf isDarwin (
  optionalAttrs (options ? system.keyboard) {
    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  }
)
