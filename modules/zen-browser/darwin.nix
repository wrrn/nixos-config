{
  pkgs,
  lib,
  device-conf,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkIf;
  inherit (device-conf) username;
in
## Install via homebrew so that we are able to get our passwords from
## 1password.
mkIf isDarwin {
  homebrew = {
    enable = true;
    casks = [
      "zen"
    ];
  };
  home-manager.users.${username}.programs.zen-browser.package = null;
}
