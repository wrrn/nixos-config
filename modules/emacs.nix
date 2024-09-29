{
  username,
  dotfiles,
  pkgs,
  ...
}:
{
  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  environment.variables.EDITOR = "emacs";

  home-manager.users.${username}.home.file.emacs = {
    source = "${dotfiles.emacs}/.emacs.d";
    target = ".emacs.d";
    recursive = true;
  };
}
