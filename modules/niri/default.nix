{ inputs, pkgs, ... }:
let
in
{
  imports = [
    ./niri.nix
    ./xwayland-satellite.service.nix
  ];

  # For adding auth when an app needs to sudo.
  security.polkit.enable = true;
}
