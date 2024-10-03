{ config, ... }:
let
  hostPlatform = config.device-conf.architecture;
in
{
  # Set the nixpkgs hostPlatform to the specific
  nixpkgs.hostPlatform = hostPlatform;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flasks feature and accompanying new nix cli.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
