{
  pkgs,
  device-conf,
  inputs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (inputs) dotfiles;
in
{
  nixpkgs.overlays = [
    # niri.overlays.niri
    dotfiles.overlays.default
  ];

  programs.waybar.enable = true;

  home-manager.users.${username}.home.file.dot-waybar = {
    source = "${pkgs.dotfiles.waybar}/.config/waybar";
    target = ".config/waybar";
    recursive = true;
  };
}
