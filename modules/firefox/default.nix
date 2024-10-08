{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles;
  inherit (config.device-conf) username;
  inherit (pkgs.stdenv) isDarwin;

  mozillaConfigPath = if isDarwin then "Library/Application Support/Mozilla" else ".mozilla";

  firefoxConfigPath =
    if isDarwin then "Library/Application Support/Firefox" else "${mozillaConfigPath}/firefox";

  profilesPath = if isDarwin then "${firefoxConfigPath}/Profiles" else firefoxConfigPath;

  firefoxPackage = if isDarwin then pkgs.firefox-devedition-darwin else pkgs.firefox-devedition;
in
{

  nixpkgs.overlays = [ inputs.wrrnpkgs.overlay.macApps ];

  home-manager.users.${username} = {
    programs.firefox = {
      enable = true;
      package = firefoxPackage;
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

        Homepage = {
          StartPage = "homepage";
          URL = "about:blank";
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

        FirefoxHome = # Make new tab only show search
          {
            Search = true;
            TopSites = false;
            SponsoredTopSites = false;
            Highlights = false;
            Pocket = false;
            SponsoredPocket = false;
            Snippets = false;
          };
      };

      nativeMessagingHosts = [
        pkgs.tridactyl-native
      ];
      profiles.default = {
        id = 0;
        containersForce = true;
        isDefault = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "devtools.chrome.enabled" = true;
          "devtools.debugger.remote-enabled" = true;
        };
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
      };
    };

    home.file.firefox-theme = {
      source = inputs.dotfiles.firefox-theme;
      target = "${profilesPath}/default/chrome/theme";
      recursive = true;
    };

    home.file.dot-tridactyl = {
      source = "${dotfiles.tridactyl}/.config/tridactyl";
      target = ".config/tridactyl";
      recursive = true;
    };
  };
}
