{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username platform;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${system};
  nur = inputs.nur.legacyPackages.${system};
  inherit (nur.repos.rycee) firefox-addons;

  module = if platform.isDarwin then ./darwin.nix else { };
in

{

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
      policies = {
        DontCheckDefaultBrowser = true;
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableFirefoxScreenshots = true;

        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "never"; # Previously appeared when pressing alt

        OverrideFirstRunPage = "";
        PictureInPicture.Enabled = false;
        PromptForDownloadLocation = false;

        HardwareAcceleration = true;
        TranslateEnabled = true;
        DNSOverHTTPS = false;

        Homepage = {
          StartPage = "homepage";
          URL = "https://cpu.land/the-basics";
          Additional = [ "https://www.lightnote.co/" ];
        };

        UserMessaging = {
          UrlbarInterventions = false;
          SkipOnboarding = true;
        };

        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
        };

        EnableTrackingProtection = {
          Value = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        # Make new tab only show search
        FirefoxHome = {
          Search = false;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
        };

        Preferences = {
          "network.trr.mode" = {
            Value = 5;
            Status = "locked";
          };

          "toolkit.legacyUserProfileCustomizations.stylesheets" = {
            Value = true;
          };

          "devtools.chrome.enabled" = {
            Value = true;
          };

          "devtools.debugger.remote-enabled" = {
            Value = true;
          };

        };
      };

      nativeMessagingHosts = [
        pkgs.tridactyl-native
      ];

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        containersForce = true;
        containers = {

          personal = {
            id = 0;
            color = "green";
            icon = "circle";
            name = "personal";
          };

          banking = {
            id = 1;
            color = "purple";
            icon = "circle";
            name = "banking";
          };
        };

        extensions.packages = [
          firefox-addons.ublock-origin
          firefox-addons.privacy-badger
          firefox-addons.onepassword-password-manager
        ];
      };
    };

    home.file.dot-tridactyl = {
      source = "${dotfiles.tridactyl}/.config/tridactyl";
      target = ".config/tridactyl";
      recursive = true;
    };
  };
}
