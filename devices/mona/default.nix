{ home-manager, ... }@inputs:
let
  device-conf = (import ./device.nix inputs);
in
{

  modules = [
    # Default modules
    ../../modules/nixos
    ../../modules/nix
    ../../modules/home-manager
    ../../modules/fixed-packages

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
    ../../modules/tailscale
    ../../modules/user
    ../../modules/zen-browser
    ../../modules/postscript
  ];

  specialArgs = { inherit inputs device-conf; };
}
