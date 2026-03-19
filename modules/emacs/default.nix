{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles wrrnpkgs;
  inherit (device-conf) username;
  inherit (pkgs.stdenv) isLinux;
  inherit (pkgs.stdenv.hostPlatform.uname) system;

  emacsPackage =
    {
      Darwin = pkgs.wrrn.emacs-plus;
      # Use the pure gtk version so that it works without xwayland
      Linux = pkgs.emacs30-pgtk;
    }
    .${system};

  # Need to include the packages in home-manager for macos because darwin won't
  # the emacs daemon story for darwin doesn't work as expected.
  homeManagerPackageLists = {
    Darwin = [
      pkgs.wrrn.emacs-plus
      pkgs.wrrn.emacs-plus-client
    ];

    Linux = [ emacsPackage.Linux ];
  };

  homeManagerPackages = homeManagerPackageLists.${system} or [ ];
in
{
  nixpkgs.overlays = [
    wrrnpkgs.overlays.default
    dotfiles.overlays.default
  ];

  environment.variables.EDITOR = "emacsclient";

  environment.systemPackages = with pkgs; [
    ispell
    python3
    emacs.pkgs.vterm
    glibtool
    cmake
    taplo
    gopls
    pyright
    typescript-language-server
  ];

  home-manager.users.${username} = {
    services.emacs = {
      enable = true;
      package = emacsPackage;
      client.enable = true;
      defaultEditor = true;
      startWithUserSession = "graphical";
    };

    programs.emacs = {
      enable = true;
      package = emacsPackage;
    };

    xdg.desktopEntries.emacsclient = {
      name = "Emacs (Client)";
      genericName = "Text Editor";
      comment = "Edit text with emacsclient";
      exec = "emacsclient -c -a emacs %F";
      icon = "emacs";
      terminal = false;
      categories = [ "Development" "TextEditor" ];
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
    };

    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "application/x-extension-htm" = "zen-beta.desktop";
        "application/x-extension-html" = "zen-beta.desktop";
        "application/x-extension-shtml" = "zen-beta.desktop";
        "application/x-extension-xht" = "zen-beta.desktop";
        "application/x-extension-xhtml" = "zen-beta.desktop";
        "application/xhtml+xml" = "zen-beta.desktop";
        "text/html" = "zen-beta.desktop";
        "video/mp4" = "zen.desktop";
        "x-scheme-handler/chrome" = "zen-beta.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
      };
      defaultApplications = {
        "application/x-extension-htm" = "zen-beta.desktop";
        "application/x-extension-html" = "zen-beta.desktop";
        "application/x-extension-shtml" = "zen-beta.desktop";
        "application/x-extension-xht" = "zen-beta.desktop";
        "application/x-extension-xhtml" = "zen-beta.desktop";
        "application/xhtml+xml" = "zen-beta.desktop";
        "text/html" = "zen-beta.desktop";
        "text/plain" = "emacsclient.desktop";
        "video/mp4" = "zen.desktop";
        "x-scheme-handler/chrome" = "zen-beta.desktop";
        "x-scheme-handler/discord-455712169795780630" = "discord-455712169795780630.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/msteams" = "teams-for-linux.desktop";
      };
    };

    home = {
      packages = [
        pkgs.global
      ];
      # ++ homeManagerPackages;

      file.dot-emacs = {
        source = "${pkgs.dotfiles.emacs}/.config/emacs";
        target = ".config/emacs";
        recursive = true;
      };
    };
  };
}
