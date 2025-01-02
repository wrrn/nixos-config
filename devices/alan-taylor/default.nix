{ inputs, ... }:
let
  inherit (inputs) home-manager niri wrrnhosts;
  inherit (inputs.flake-utils.lib) system;
in
{
  nixpkgs.hostPlatform = system.x86_64-linux;

  imports = [
    # options definitions
    ../../options.nix

    # Default modules
    ../../modules/nixos
    ../../modules/nix
    ../../modules/home-manager

    # Set device options
    ./options.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    home-manager.nixosModules.home-manager
    wrrnhosts.nixosModules.hosts

    ../../modules/1password
    ../../modules/audio
    ../../modules/bluetooth
    ../../modules/emacs
    ../../modules/firefox
    ../../modules/fonts
    ../../modules/git
    ../../modules/ghostty
    ../../modules/home-manager
    ../../modules/keyboard
    ../../modules/locale
    ../../modules/networking
    ../../modules/niri
    ../../modules/printing
    ../../modules/sddm
    ../../modules/shell
    ../../modules/steam
    ../../modules/user
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
