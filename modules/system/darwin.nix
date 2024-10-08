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
  optional = a: optionalAttrs (attrPathsMatch a options) a;

in
mkIf isDarwin (
  optional {
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
        appswitcher-all-displays = true;
      };

      NSGlobalDomain = {
        # Enable tap to click.
        "com.apple.mouse.tapBehavior" = 1;
        KeyRepeat = 1;
        InitialKeyRepeat = 15;
        AppleShowScrollBars = "WhenScrolling";
        AppleICUForce24HourTime = true;
      };
    };
  }
  // optional {
    documentation = {
      enable = true;
      doc.enable = true;
      info.enable = true;
      man.enable = true;
    };
  }

  // optional {
    security.pam.enableSudoTouchIdAuth = true;
  }
)
