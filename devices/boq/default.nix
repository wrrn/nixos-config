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
    ../../modules/fixed-packages
    # Set device options
    ./options.nix

    home-manager.darwinModules.home-manager
    ../../modules/darwin
    ../../modules/1password
    ../../modules/amethyst
    ../../modules/apps
    ../../modules/containers
    ../../modules/cold-turkey
    ../../modules/emacs
    ../../modules/email
    ../../modules/fonts
    ../../modules/gauntlet
    ../../modules/ghostty
    ../../modules/git
    ../../modules/go
    ../../modules/jujutsu
    ../../modules/keyboard
    ../../modules/mongo
    ../../modules/networking
    ../../modules/shell
    ../../modules/sketchybar
    ../../modules/system
    ../../modules/user
    ../../modules/zen-browser
    ../../modules/postscript
  ];
}
