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

    home = {
      packages = [
        pkgs.global
      ]
      ++ homeManagerPackages;

      file.dot-emacs = {
        source = "${pkgs.dotfiles.emacs}/.config/emacs";
        target = ".config/emacs";
        recursive = true;
      };
    };
  };
}
