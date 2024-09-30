{
  username,
  dotfiles,
  pkgs,
  ...
}:
{
  programs.fish.enable = true;

  users.users.warren.shell = pkgs.fish;

  home-manager.users.${username} = {
    programs.fish.enable = true;
    home.file.fish = {
      source = "${dotfiles.fish}/.config/fish";
      target = ".config/fish";
      recursive = true;
    };
  };
}
