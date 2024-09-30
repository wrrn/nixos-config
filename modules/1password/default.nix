{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = [
      pkgs._1password
      pkgs._1password-gui
    ];
  };
}
