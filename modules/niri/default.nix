{ inputs, ... }:
{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  imports = [
    ./niri.nix
    ./xwayland-satellite.service.nix
  ];

}
