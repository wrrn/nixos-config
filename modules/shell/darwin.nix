{
  pkgs,
  device-conf,
  ...
}:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      terminal-notifier
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    ];
  };
}
