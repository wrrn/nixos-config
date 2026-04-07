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

  module = lib.systemModule {
    darwin = ./darwin.nix;
    linux = ./linux.nix;
  };
in

{
  nixpkgs.overlays = [ inputs.nur.overlays.default ];

  home-manager.sharedModules = [
    inputs.zen-browser.homeModules.beta
  ];

  imports = [
    module
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
      };
    };

    home.file.dot-tridactyl = browser.tridactylDotfile;
  };
}
