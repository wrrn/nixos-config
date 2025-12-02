{
  pkgs,
  lib,
  device-conf,
  ...
}:
let
  inherit (device-conf) username;
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
in
mkIf isDarwin {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      terminal-notifier
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    ];
  };
}
