{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.hostPlatform) isDarwin;
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
