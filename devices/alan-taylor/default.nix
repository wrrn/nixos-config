{ inputs, ... }:
let
  inherit (inputs) home-manager;
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

    niri.nixosModules.niri
    home-manager.nixosModules.home-manager

    ../../modules/1password
    ../../modules/audio
    ../../modules/emacs
    ../../modules/firefox
    ../../modules/fonts
    ../../modules/git
    ../../modules/home-manager
    ../../modules/keyboard
    ../../modules/locale
    ../../modules/networking
    ../../modules/niri
    ../../modules/sddm
    ../../modules/shell
    ../../modules/steam
    ../../modules/user
    ../../modules/wezterm
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
