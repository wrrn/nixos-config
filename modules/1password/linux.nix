{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isLinux;
  inherit (config.device-conf) username;
in
mkIf isLinux {
  home-manager.users.${username} = {
    home.packages = [
      pkgs._1password-gui
    ];
  };

}
