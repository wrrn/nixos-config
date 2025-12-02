{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkIf;
in
{
  config = mkIf isDarwin {
    nixpkgs.overlays = [ inputs.wrrnpkgs.overlays.macApps ];
    homebrew = {
      enable = true;
      casks = [
        "ghostty"
      ];
    };
  };
}
