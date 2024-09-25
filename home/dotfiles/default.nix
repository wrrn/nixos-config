# We need to pull in the dotfiles
{ dotfiles, ... }:
{
  home.file = {
    fish = {
      source = "${dotfiles.fish}/.config/fish"; # This should be path the fish config directory.
      target = ".config/fish";
      recursive = true;
    };

    emacs = {
      source = "${dotfiles.emacs}/.emacs.d";
      target = ".emacs.d";
      recursive = true;
    };

    bat = {
      source = "${dotfiles.bat}/.config/bat";
      target = ".config/bat";
      recursive = true;
    };

    starship = {
      source = "${dotfiles.starship}/.config/starship";
      target = ".config/starship";
      recursive = true;
    };

    wezterm = {
      source = "${dotfiles.wezterm}/.wezterm.lua";
      target = ".wezterm.lua";
    };

    tridactyl = {
      source = "${dotfiles.tridactyl}/.config/tridactyl";
      target = ".config/tridactyl";
      recursive = true;
    };
  };
}
