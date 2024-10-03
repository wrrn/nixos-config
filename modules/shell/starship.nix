{ config, inputs, ... }:
let
  inherit (inputs) dotfiles;
  inherit (config.device-conf) username;
in
{
  home-manager.users.${username} = {
    programs.starship.enable = true;
    home.file.starship = {
      source = "${dotfiles.starship}/.config/starship";
      target = ".config/starship";
      recursive = true;
    };
  };

}
