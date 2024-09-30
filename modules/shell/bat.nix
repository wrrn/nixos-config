{
  dotfiles,
  pkgs,
  username,
  ...
}:
{
  home-manager.users.${username} = {
    home.packages = [ pkgs.bat ];
    home.file.dot-bat = {
      source = "${dotfiles.bat}/.config/bat";
      target = ".config/bat";
      recursive = true;
    };
  };
}
