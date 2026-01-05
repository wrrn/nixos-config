{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles wrrnpkgs nur;
  inherit (device-conf) username platform;
  inherit (pkgs.nur.repos.rycee) firefox-addons;

  module = if platform.isDarwin then ./darwin.nix else { };
in

{

  home-manager.sharedModules = [
    inputs.zen-browser.homeModules.beta
  ];

  nixpkgs.overlays = [
    wrrnpkgs.overlays.default
    dotfiles.overlays.default
    nur.overlays.default
  ];

  imports = [
    module
  ];

  home-manager.users.${username} = {
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
      source = "${pkgs.dotfiles.tridactyl}/.config/tridactyl";
      target = ".config/tridactyl";
      recursive = true;
    };
  };
}
