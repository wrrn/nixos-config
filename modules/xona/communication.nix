{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username} = {
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/discord-455712169795780630" = "discord-455712169795780630.desktop";
      "x-scheme-handler/msteams" = "teams-for-linux.desktop";
    };

    home.packages = with pkgs; [
      teams-for-linux
      slack
    ];
  };
}
