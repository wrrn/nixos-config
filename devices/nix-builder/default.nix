{
  home-manager,
  niri,
  flake-utils,
  flaky-falcon,
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
    # ../../modules/gcp-image
    ../../modules/nix

    home-manager.nixosModules.home-manager

    ../../modules/home-manager
    ../../modules/build-tools
    ../../modules/containers
    ../../modules/git
    ../../modules/go
    ../../modules/gpg
    ../../modules/jujutsu
    ../../modules/locale
    ../../modules/shell
    ../../modules/ssh
    ../../modules/sudo
    ../../modules/user
  ];

  specialArgs = {
    inherit inputs device-conf lib;
  };
}
