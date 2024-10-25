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

  nixpkgs.overlays = [ dotfiles.overlays.default ];

  home-manager.users.${username} = {
    home.packages = [
      pkgs.wezterm
    ];

    home.file.wezterm = {
      source = "${pkgs.dotfiles.wezterm}/.wezterm.lua";
      target = ".config/wezterm/wezterm.lua";
    };
  };
}
