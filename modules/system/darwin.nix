_: {
  system.defaults = {
    menuExtraClock = {
      ShowDayOfWeek = false;
      ShowDayOfMonth = false;
      ShowDate = "never";
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

    # Enable tap to click.
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.AppleShowScrollBars = "WhenScrolling";
    NSGlobalDomain.AppleICUForce24HourTime = true;
  };

  documentation = {
    enable = true;
    doc.enable = true;
    info.enable = true;
    man.enable = true;
  };
}
