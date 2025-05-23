{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.hostPlatform) isLinux;
  inherit (lib) mkIf;
  inherit (config.device-conf) username;
in
mkIf isLinux {
  home-manager.users.${username}.programs.firefox.package = pkgs.firefox-devedition-bin;
}
