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
    ../../modules/1password
    ../../modules/amethyst
    ../../modules/apps
    ../../modules/containers
    ../../modules/emacs
    ../../modules/firefox
    ../../modules/fonts
    ../../modules/git
    ../../modules/keyboard
    ../../modules/networking
    ../../modules/shell
    ../../modules/system
    ../../modules/user
    ../../modules/wezterm
    ../../modules/pryon
  ];
}
