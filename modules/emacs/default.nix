{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles;
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
  # Start emacs-server with systemd
  nixpkgs.overlays = [ inputs.wrrnpkgs.overlay.macApps ];
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

  home-manager.users.${username}.home.file.dot-emacs = {
    source = "${dotfiles.emacs}/.emacs.d";
    target = ".emacs.d";
    recursive = true;
  };
}
