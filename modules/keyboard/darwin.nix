{
  options,
  lib,
  ...
}:
let
  inherit (lib) optionalAttrs;
in
optionalAttrs (options ? system.keyboard) {
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
}
