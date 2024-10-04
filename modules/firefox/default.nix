{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles;
  inherit (config.device-conf) username;
  firefoxPackage = {
    aarch64-darwin = pkgs.firefox-darwin;
    # Use the pure gtk version so that it works without xwayland
    x86_64-linux = pkgs.firefox;
  };

in
{
  nixpkgs.overlays = [ inputs.wrrnpkgs.overlay.macApps ];
  environment.systemPackages = [
    pkgs.firefoxpwa
  ];

  home-manager.users.${username} = {
    programs.firefox = {
      enable = true;
      package = firefoxPackage.${pkgs.hostPlatform.system};

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

        Homepage.StartPage = "previous-session";

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
        pkgs.firefoxpwa
      ];
      profiles.default = {
        id = 0;
        containersForce = true;
        isDefault = true;
        settings = {
          # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
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
        # userChrome = ''
        # @import "./theme/userChrome.css"
        # '';
      };
    };
    # home.file.".mozilla/firefox/default/chrome/theme".source = inputs.dotfiles.firefox-theme;

    home.file.dot-tridactyl = {
      source = "${dotfiles.tridactyl}/.config/tridactyl";
      target = ".config/tridactyl";
      recursive = true;

    };
  };
}
