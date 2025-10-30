{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkIf;
  inherit (config.device-conf) username;
in
mkIf isLinux {
  home-manager.users.${username}.home.packages = [ pkgs.wrrn.ghostty ];
}
