{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;

  desktop = "firefox.desktop";

  browserMimeTypes = [
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/x-extension-xht"
    "application/x-extension-xhtml"
    "application/xhtml+xml"
    "text/html"
    "x-scheme-handler/chrome"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
  ];

  mimeAssociations = builtins.listToAttrs (
    map (mime: {
      name = mime;
      value = desktop;
    }) browserMimeTypes
  );

  otherHandlers = {
    "x-scheme-handler/onepassword" = "1password.desktop";
    "x-scheme-handler/zoommtg" = "Zoom.desktop";
    "x-scheme-handler/zoomus" = "Zoom.desktop";
  };
in
{
  home-manager.users.${username} =
    { config, ... }:
    {
      programs.firefox = {
        package = pkgs.firefox-bin;
        # Opt in to home-manager's new XDG default (the legacy default is
        # ~/.mozilla/firefox while home.stateVersion < 26.05).
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };

      xdg.mimeApps = {
        enable = true;
        associations.added = mimeAssociations // otherHandlers;
        defaultApplications = mimeAssociations // otherHandlers;
      };
    };
}
