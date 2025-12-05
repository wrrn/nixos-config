{
  home-manager,
  niri,
  wrrnhosts,
  flake-utils,
  nixpkgs,
  ...
}@inputs:
let
  device-conf = (import ./device.nix inputs);
  deviceLib = import ../../lib;
  lib = deviceLib.extendLib nixpkgs.lib device-conf.platform;
in
{

  modules = [
    # Default modules
    ../../modules/nixos
    ../../modules/nix
    ../../modules/home-manager
    ../../modules/fixed-packages

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./bootloader.nix

    home-manager.nixosModules.home-manager
    wrrnhosts.nixosModules.hosts

    ../../modules/1password
    ../../modules/audio
    ../../modules/bluetooth
    ../../modules/build-tools
    ../../modules/containers
    ../../modules/emacs
    ../../modules/email
    ../../modules/fonts
    ../../modules/ghostty
    ../../modules/git
    ../../modules/go
    ../../modules/jujutsu
    ../../modules/keyboard
    ../../modules/locale
    ../../modules/networking
    ../../modules/niri
    ../../modules/printing
    ../../modules/sddm
    ../../modules/shell
    ../../modules/ssh
    ../../modules/sudo
    ../../modules/tailscale
    ../../modules/user
    ../../modules/zen-browser
  ];

  specialArgs = {
    inherit inputs device-conf lib;
  };
}
