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
  home-manager.users.${username} = {
    home.packages = [
      pkgs.wezterm
    ];

    home.file.wezterm = {
      source = "${dotfiles.wezterm}/.wezterm.lua";
      target = ".config/wezterm/wezterm.lua";
    };
  };
}
