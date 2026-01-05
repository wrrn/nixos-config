{
  device-conf,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (inputs) dotfiles wrrnpkgs nur;
  inherit (device-conf) username;
  inherit (pkgs.nur.repos.rycee) firefox-addons;
  platform = device-conf.platform.parsed.kernel.name;

  platformConfigs = {
    darwin = ./darwin.nix;
    linux = ./linux.nix;
  };

  platformConfig = import platformConfigs.${platform} {
    inherit username pkgs;
  };
in
{

  nixpkgs.overlays = [
    wrrnpkgs.overlays.default
    dotfiles.overlays.default
    nur.overlays.default
  ];

  imports = [
    platformConfig.module
  ];

  home-manager.users.${username} = {
    programs.firefox = {
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

      profiles.dev-edition-default = {
        id = 0;
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

        userChrome = ''
          @import "./theme/userChrome.css"
        '';

        extensions.packages = [
          firefox-addons.ublock-origin
          firefox-addons.privacy-badger
          firefox-addons.onepassword-password-manager
        ];
      };
    };

    home.file.firefox-theme = {
      source = pkgs.dotfiles.firefox-theme;
      target = "${platformConfig.profilesPath}/dev-edition-default/chrome/theme";
      recursive = true;
    };

    home.file.dot-tridactyl = {
      source = "${pkgs.dotfiles.tridactyl}/.config/tridactyl";
      target = ".config/tridactyl";
      recursive = true;
    };
  };
}
