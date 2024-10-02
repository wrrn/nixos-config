{
  username,
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs) dotfiles;
in
{
  # Start emacs-server with systemd
  services.emacs = {
    enable = true;
    # Use the pure gtk version so that it works without xwayland
    package = pkgs.emacs29-pgtk;
  };

  environment.variables.EDITOR = "emacs";

  environment.systemPackages = with pkgs; [
    ispell
    python3
  ];

  home-manager.users.${username}.home.file.dot-emacs = {
    source = "${dotfiles.emacs}/.emacs.d";
    target = ".emacs.d";
    recursive = true;
  };
}
