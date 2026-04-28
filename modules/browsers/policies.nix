{
  firefox-addons,
  pkgs,
  dotfiles,
}:
{
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

  extensions = [
    firefox-addons.ublock-origin
    firefox-addons.privacy-badger
    firefox-addons.onepassword-password-manager
  ];

  tridactylDotfile = {
    source = "${dotfiles.tridactyl}/.config/tridactyl";
    target = ".config/tridactyl";
    recursive = true;
  };
}
