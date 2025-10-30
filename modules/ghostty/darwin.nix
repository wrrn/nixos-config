{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkIf;
in
mkIf isDarwin {
  homebrew = {
    enable = true;
    casks = [
      "ghostty"
    ];
  };
}
