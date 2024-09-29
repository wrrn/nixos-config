{ username, dotfiles, ... }:
{
  home-manager.user.${username} = {
    programs.starship.enable = true;
    home.file.starship = {
      source = "${dotfiles.starship}/.config/starship";
      target = ".config/starship";
      recursive = true;
    };
  };

}
