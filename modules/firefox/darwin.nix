{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.hostPlatform) isDarwin;
  inherit (lib) mkIf;
  inherit (config.device-conf) username;
in
## Install firefox via homebrew so that we are able to get our passwords from
## 1password.
mkIf isDarwin {
  homebrew = {
    enable = true;
    casks = [
      "firefox@developer-edition"
    ];
  };
  home-manager.users.${username}.programs.firefox.package = null;
}
