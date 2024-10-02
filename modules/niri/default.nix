{ inputs, ... }:
{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  imports = [
    ./niri.nix
    ./xwayland-satellite.service.nix
  ];

  # For adding auth when an app needs to sudo.
  security.polkit.enable = true;
  environment.systemPackages = [
    polkit-kde-agent
  ];
}
