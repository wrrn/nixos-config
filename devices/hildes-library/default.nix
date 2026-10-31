{ nixpkgs, ... }@inputs:
let
  device-conf = (import ./device.nix inputs);
  deviceLib = import ../../lib;
  lib = deviceLib.extendLib nixpkgs.lib device-conf.platform;
in
{

  modules = [
    # Default modules
    ../../modules/nixos
    ../../modules/locale

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./system.nix
    ./session.nix
    ./wifi.nix
    ./libreoffice
  ];

  specialArgs = {
    inherit inputs device-conf lib;
  };
}
