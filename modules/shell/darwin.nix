{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.device-conf) username;
  inherit (lib) mkIf;
  inherit (pkgs.hostPlatform) isDarwin;
in
mkIf isDarwin {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      terminal-notifier
      google-cloud-sdk
    ];
  };
}
