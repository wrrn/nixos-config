{
  device-conf,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username platform;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${system};
  inherit (pkgs.nur.repos.rycee) firefox-addons;
  browser = import ../policies.nix { inherit firefox-addons pkgs dotfiles; };

  platformConfigs = {
    darwin = ./darwin.nix;
    linux = ./linux.nix;
  };

  platformConfig = import platformConfigs.${platform.parsed.kernel.name} {
    inherit username pkgs;
  };
in
{
  nixpkgs.overlays = [ inputs.nur.overlays.default ];

  home-manager.sharedModules = [
    inputs.zen-browser.homeModules.beta
  ];

  imports = [
    platformConfig.module
  ];

  home-manager.users.${username} = {
    xdg.mimeApps = {
      associations.added = {
        "application/x-extension-htm" = "zen-beta.desktop";
        "application/x-extension-html" = "zen-beta.desktop";
        "application/x-extension-shtml" = "zen-beta.desktop";
        "application/x-extension-xht" = "zen-beta.desktop";
        "application/x-extension-xhtml" = "zen-beta.desktop";
        "application/xhtml+xml" = "zen-beta.desktop";
        "text/html" = "zen-beta.desktop";
        "video/mp4" = "zen.desktop";
        "x-scheme-handler/chrome" = "zen-beta.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/onepassword" = "1password.desktop";
        "x-scheme-handler/zoommtg" = "Zoom.desktop";
        "x-scheme-handler/zoomus" = "Zoom.desktop";
      };
      defaultApplications = {
        "application/x-extension-htm" = "zen-beta.desktop";
        "application/x-extension-html" = "zen-beta.desktop";
        "application/x-extension-shtml" = "zen-beta.desktop";
        "application/x-extension-xht" = "zen-beta.desktop";
        "application/x-extension-xhtml" = "zen-beta.desktop";
        "application/xhtml+xml" = "zen-beta.desktop";
        "text/html" = "zen-beta.desktop";
        "video/mp4" = "zen.desktop";
        "x-scheme-handler/chrome" = "zen-beta.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/onepassword" = "1password.desktop";
        "x-scheme-handler/zoommtg" = "Zoom.desktop";
        "x-scheme-handler/zoomus" = "Zoom.desktop";
      };
    };

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
      inherit (browser) policies nativeMessagingHosts;

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        containersForce = true;
        containers = browser.containers;
        extensions.packages = browser.extensions;
        settings = {
          "network.protocol-handler.expose.zoommtg" = false;
          "network.protocol-handler.external.zoommtg" = true;
          "network.protocol-handler.expose.zoomus" = false;
          "network.protocol-handler.external.zoomus" = true;
        };

        # Native userChrome option from the Firefox-based hm module:
        # writes to <profilesPath>/default/chrome/userChrome.css.
        userChrome = ''
          @import "./theme/userChrome.css"
        '';

      };
    };

    home.file.dot-tridactyl = browser.tridactylDotfile;
  };
}
