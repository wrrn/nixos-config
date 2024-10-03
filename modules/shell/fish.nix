{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles;
  inherit (config.device-conf) username;
in
{
  programs.fish.enable = true;

  users.users.warren.shell = pkgs.fish;

  home-manager.users.${username} = {
    home.file.fish = {
      source = "${dotfiles.fish}/.config/fish";
      target = ".config/fish";
      recursive = true;
    };
  };
}
