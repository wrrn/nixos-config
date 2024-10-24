{
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf optionalAttrs;
  inherit (pkgs.stdenv) isLinux;

in
mkIf isLinux (
  optionalAttrs (options ? programs._1password) {
    programs = {
      _1password.enable = true;
      _1password-gui.enable = true;
    };
  }
)
