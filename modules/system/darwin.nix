{
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkIf optionalAttrs attrsets;
  inherit (attrsets) isAttrs;
  attrPathsMatch =
    pattern: attrs:
    assert isAttrs pattern;
    builtins.all (
      # Compare equality between `pattern` & `attrs`.
      attr:
      # Missing attr, not equal.
      attrs ? ${attr}
      && (
        let
          lhs = pattern.${attr};
          rhs = attrs.${attr};
        in
        # If attrset check recursively
        if isAttrs lhs then isAttrs rhs && attrPathsMatch lhs rhs else true
      )
    ) (builtins.attrNames pattern);

  # AttrSet -> AttrSet
  # If the attrset is in options then we set it, otherwise, it's just an empty attrset.
  # optional = a: optionalAttrs (attrPathsMatch a options) a;
  optional = a: a;

  modules = ([
    {
      system.startup.chime = false;
    }

    (optional {
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

        spaces = {
          spans-displays = true; # Disable "Displays have separate spaced"
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
          _HIHideMenuBar = true;
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
    })

    (optional {
      documentation = {
        enable = true;
        doc.enable = true;
        info.enable = true;
        man.enable = true;
      };
    })
  ]);

in
mkIf isDarwin (lib.foldl lib.attrsets.recursiveUpdate { } modules)
