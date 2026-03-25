{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${system};
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
