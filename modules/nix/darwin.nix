{
  lib,
  options,
  ...
}:
let
  inherit (lib) optionalAttrs;
in
optionalAttrs (options ? nix.enable) {
  nix.enable = true;
}
