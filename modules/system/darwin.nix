{
  lib,
  ...
}:
let
  modules = [
    {
      system.startup.chime = false;
    }

    {
      system.defaults = {

        menuExtraClock = {
          ShowDayOfWeek = false;
          ShowDayOfMonth = false;
          ShowDate = 0;
          Show24Hour = true;
        };

        finder = {
          AppleShowAllFiles = true;
          ## Set the preferred view style to list view.
          FXPreferredViewStyle = "Nlsv";
          QuitMenuItem = true;
          ShowPathbar = true;
          _FXShowPosixPathInTitle = true;
          _FXSortFoldersFirst = true;
        };

        dock = {
          static-only = true;
          show-recents = false;
          orientation = "left";
          mru-spaces = false;
          mouse-over-hilite-stack = true;
          magnification = true;
          autohide = true;
          autohide-delay = 1000.0;
          appswitcher-all-displays = true;
        };

        trackpad = {
          Clicking = true; # Turn on tap to click
        };

        NSGlobalDomain = {
          # Enable tap to click.
          "com.apple.mouse.tapBehavior" = 1;
          KeyRepeat = 1;
          InitialKeyRepeat = 15;
          AppleShowScrollBars = "WhenScrolling";
          AppleICUForce24HourTime = true;
          # _HIHideMenuBar = true; #Uncomment to autohide menubar
        };
        # Note this might not work. I might have to do something other than optional
        CustomUserPreferences = {
          "com.apple.universalaccess" = {
            grayscale = 1;
            differentiateWithoutColor = 1;
            increaseContrast = 1;
            reduceMotion = 1;
            reduceTransparency = 1;
          };
        };
      };
    }

    {
      documentation = {
        enable = true;
        doc.enable = true;
        info.enable = true;
        man.enable = true;
      };
    }
  ];

in
lib.foldl lib.attrsets.recursiveUpdate { } modules
