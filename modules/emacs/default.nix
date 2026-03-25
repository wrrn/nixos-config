{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (pkgs.stdenv) isLinux;
  inherit (pkgs.stdenv.hostPlatform.uname) system;
  dotfiles = inputs.dotfiles.packages.${device-conf.platform.system};
  wrrnpkgs = inputs.wrrnpkgs.packages.${device-conf.platform.system};

  emacsPackage =
    {
      Darwin = wrrnpkgs.emacs-plus;
      # Use the pure gtk version so that it works without xwayland
      Linux = pkgs.emacs30-pgtk;
    }
    .${system};

  # Need to include the packages in home-manager for macos because darwin won't
  # the emacs daemon story for darwin doesn't work as expected.
  homeManagerPackageLists = {
    Darwin = [
      wrrnpkgs.emacs-plus
      wrrnpkgs.emacs-plus-client
    ];

    Linux = [ emacsPackage.Linux ];
  };

  homeManagerPackages = homeManagerPackageLists.${system} or [ ];
in
{

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

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "emacsclient.desktop";
      };
    };

    home = {
      packages = [
        pkgs.global
      ];
      # ++ homeManagerPackages;

      file.dot-emacs = {
        source = "${dotfiles.emacs}/.config/emacs";
        target = ".config/emacs";
        recursive = true;
      };
    };
  };
}
