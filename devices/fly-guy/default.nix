{
  home-manager,
  niri,
  wrrnhosts,
  flake-utils,
  ...
}@inputs:
let
  inherit (inputs) home-manager niri wrrnhosts;
  device-conf = (import ./device-config.nix inputs);
in
{

  modules = [
    # Default modules
    ../../modules/nixos
    ../../modules/nix
    ../../modules/home-manager

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
    ../../modules/go
    ../../modules/home-manager
    ../../modules/keyboard
    ../../modules/locale
    ../../modules/networking
    ../../modules/niri
    ../../modules/printing
    # ../../modules/sddm
    ../../modules/shell
    ../../modules/user

    {
      nixpkgs.hostPlatform = device-conf.platform.system;

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable bluetooth
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;

      # Enable the X11 windowing system.
      services.xserver.enable = true;

      # Enable the GNOME Desktop Environment.
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;

    }
  ];

  specialArgs = {
    inherit inputs;
    inherit device-conf;
  };
}
