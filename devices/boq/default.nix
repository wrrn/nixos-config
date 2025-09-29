{ inputs, ... }:
let
  inherit (inputs) home-manager;
  inherit (inputs.flake-utils.lib) system;

in
{

  nixpkgs.hostPlatform = system.aarch64-darwin;

  imports = [
    # options definitions
    ../../options.nix

    # Default modules
    ../../modules/nixos
    ../../modules/nix
    ../../modules/home-manager

    # Set device options
    ./options.nix

    home-manager.darwinModules.home-manager
    ../../modules/darwin
    ../../modules/1password
    ../../modules/amethyst
    ../../modules/apps
    ../../modules/containers
    ../../modules/emacs
    ../../modules/fonts
    ../../modules/gauntlet
    ../../modules/ghostty
    ../../modules/git
    ../../modules/go
    ../../modules/keyboard
    ../../modules/mongo
    ../../modules/networking
    ../../modules/shell
    ../../modules/system
    ../../modules/user
    ../../modules/zen-browser
    ../../modules/postscript
  ];
}
