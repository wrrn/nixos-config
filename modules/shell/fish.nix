{ username, ... }:
{
  programs.fish.enable = true;

  home-manager.user.${username} = {
    programs.fish.enable = true;
    home.file.fish = {
      source = "${dotfiles.fish}/.config/fish";
      target = ".config/fish";
      recursive = true;
    };
  };
}
