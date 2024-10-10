{
  options,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) optionalAttrs mkIf;
in
mkIf isLinux (
  optionalAttrs (options ? services.xserver) {
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
      options = "ctrl:nocaps";
    };

    console.useXkbConfig = true;
  }
)
