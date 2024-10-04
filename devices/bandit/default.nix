{ pkgs, ... }:
{
  imports = [
    ./options.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  # system.stateVersion = 5;

  # The platform the configuration will be used on.

}
