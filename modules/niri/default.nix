{ inputs, pkgs, ... }:
{
  imports = [
    ./niri.nix
    ./waybar.nix
    ./mako.nix
    ./idle.nix
    ./polkit.nix
    ./xwayland-satellite.service.nix
  ];

}
