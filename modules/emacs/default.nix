{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles wrrnpkgs;
  inherit (config.device-conf) username;
  inherit (pkgs.stdenv) isLinux;
  inherit (pkgs.hostPlatform.uname) system;

  emacsPackage =
    {
      Darwin = pkgs.emacs-plus;
      # Use the pure gtk version so that it works without xwayland
      Linux = pkgs.emacs29-pgtk;
    }
    .${system};
in
{
  nixpkgs.overlays = [
    wrrnpkgs.overlays.macApps
    dotfiles.overlays.default
  ];

  # Start emacs-server with systemd
  services.emacs = {
    enable = isLinux;
    package = emacsPackage;
  };

  environment.variables.EDITOR = "emacs";

  environment.systemPackages = with pkgs; [
    ispell
    python3
    emacsPackages.vterm
    glibtool
    cmake
  ];

  home-manager.users.${username}.home = {
    packages = [
      pkgs.global
    ];

    file.dot-emacs = {
      source = "${pkgs.dotfiles.emacs}/.config/emacs";
      target = ".config/emacs";
      recursive = true;
    };
  };
}
