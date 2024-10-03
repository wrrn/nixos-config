{ config, ... }:
let
  inherit (config.build-conf) username;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./options.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
