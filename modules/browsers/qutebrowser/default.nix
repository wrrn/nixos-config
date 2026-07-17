{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;

  desktop = "org.qutebrowser.qutebrowser.desktop";

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
in
{
  home-manager.users.${username} = {
    programs.qutebrowser = {
      enable = true;
      loadAutoconfig = true;
    };

    xdg.mimeApps = {
      enable = true;
      associations.added = mimeAssociations // {
        "x-scheme-handler/onepassword" = "1password.desktop";
        "x-scheme-handler/zoommtg" = "Zoom.desktop";
        "x-scheme-handler/zoomus" = "Zoom.desktop";
      };
      defaultApplications = mimeAssociations // {
        "x-scheme-handler/onepassword" = "1password.desktop";
        "x-scheme-handler/zoommtg" = "Zoom.desktop";
        "x-scheme-handler/zoomus" = "Zoom.desktop";
      };
    };
  };
}
