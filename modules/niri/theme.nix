# theme.nix — Rosé Pine Dawn desktop theme
# Import this in your home.nix:
#   imports = [ ./theme.nix ];

{
  config,
  device-conf,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  cfg = config.myTheme;

  dark = cfg.dark;

  gtkTheme = if dark then "rose-pine-gtk" else "rose-pine-dawn-gtk";
  gtkColorScheme = if dark then "dark" else "light";
  gtk3Theme = if dark then "adw-gtk3-dark" else "adw-gtk3";
  iconTheme = "Adwaita";
  cursorTheme = if dark then "BreezeX-RosePine-Linux" else "BreezeX-RosePineDawn-Linux";
  colorScheme = if dark then "prefer-dark" else "prefer-light";

in
{

  options.myTheme.dark = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable dark variant of the Rosé Pine theme.";
  };

  config.home-manager.users.${username} = {
    # ── GTK ──────────────────────────────────────────────────────────────────────
    #
    # Strategy:
    #   GTK3 → adw-gtk3: ports libadwaita's look back to GTK3, so older apps
    #           match the style of modern GTK4 ones.
    #   GTK4 → rose-pine-dawn-gtk: applied via gtk4.extraConfig and a direct
    #           CSS override, since home-manager's gtk.theme targets GTK3.
    #
    # Note: GTK4/libadwaita apps largely ignore the theme name and instead
    # respect the color-scheme preference (light/dark) set via dconf below.
    # The gtk4 CSS file gives you the actual Rosé Pine colors in those apps.
    gtk = {
      enable = true;

      theme = {
        # adw-gtk3 makes GTK3 apps look like GTK4/libadwaita ones.
        # This is the best GTK3 compatibility story available right now.
        name = gtk3Theme;
        package = pkgs.adw-gtk3;
      };

      iconTheme = {
        name = iconTheme;
        package = pkgs.adwaita-icon-theme;
      };

      cursorTheme = {
        # rose-pine-cursor ships dawn/main/moon variants.
        # Verify the exact string with:
        #   ls $(nix build nixpkgs#rose-pine-cursor --print-out-paths)/share/icons/
        name = cursorTheme;
        package = pkgs.rose-pine-cursor;
        size = 24;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = dark;
      };

      gtk4 = {
        colorScheme = gtkColorScheme;
        theme = {
          name = gtkTheme;
          package = pkgs.rose-pine-gtk-theme;
        };
        extraConfig = {
          gtk-application-prefer-dark-theme = dark;
        };
      };
    };

    # ── dconf (color-scheme preference) ──────────────────────────────────────────
    #
    # GTK4/libadwaita apps check this to decide light vs dark mode.
    # "prefer-light" → Dawn / light palette.

    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = colorScheme;
      gtk-theme = gtk3Theme; # redundant but keeps gsettings consistent
      icon-theme = iconTheme;
      cursor-theme = cursorTheme;
    };

    # ── Wayland cursor (niri / wlroots) ──────────────────────────────────────────
    #
    # GTK settings don't reach every Wayland surface. These env vars ensure
    # the cursor theme is applied system-wide including in XWayland.

    home.sessionVariables = {
      XCURSOR_THEME = cursorTheme;
      XCURSOR_SIZE = "24";

      # Force GTK3 apps that ignore gsettings to pick up the theme
      GTK_THEME = gtk3Theme;

      # Qt theming — makes Qt apps defer to the GTK theme.
      # If Qt apps look wrong, switch to qt5ct/qt6ct instead (see below).
      QT_QPA_PLATFORMTHEME = "gtk3";
    };
  };
}
