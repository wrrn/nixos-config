{
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkIf optionalAttrs;
in
mkIf isDarwin (
  optionalAttrs (options ? nix.enable) {
    nix.enable = true;
  }
)
