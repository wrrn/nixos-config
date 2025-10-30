{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkIf;
  inherit (config.device-conf) username;
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
