{ inputs, pkgs, ... }:
{
  imports = [
    ./niri.nix
    ./waybar.nix
    ./mako.nix
    ./idle.nix
    ./polkit.nix
    ./wayland-ready.nix
    ./xwayland-satellite.service.nix
    ./theme.nix
    ./portals.nix
  ];

}
