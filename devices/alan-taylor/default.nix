{
  home-manager,
  niri,
  nixpkgs,
  wrrnhosts,
  flake-utils,
  ...
}@inputs:
let
  device-conf = (import ./options.nix inputs);
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

    {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Enable the X11 windowing system.
      services.xserver.enable = true;
    }
  ];

  specialArgs = {
    inherit inputs device-conf lib;
  };
}
