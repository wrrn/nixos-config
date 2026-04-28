{
  home-manager,
  nixpkgs,
  wrrnhosts,
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

    home-manager.darwinModules.home-manager
    wrrnhosts.darwinModules.hosts
    ../../modules/darwin

    # Default modules
    ../../modules/nixos
    ../../modules/nix
    ../../modules/home-manager
    ../../modules/fixed-packages

    ../../modules/1password
    ../../modules/apps
    ../../modules/corpoware
    ../../modules/productivity
    ../../modules/build-tools
    ## TODO: Use maccy as clipboard in macos
    # ../../modules/clipboard
    ../../modules/containers
    ../../modules/emacs
    ../../modules/email
    ../../modules/fonts
    ../../modules/ghostty
    ../../modules/git
    ../../modules/go
    ../../modules/gpg
    ../../modules/jujutsu
    ../../modules/kvm
    ../../modules/llms

    ../../modules/keyboard
    ## TODO: Add locale configs to macos
    # ../../modules/locale
    ../../modules/networking
    ## TODO: Figure out droidcam for macos
    ## ../../modules/obs
    ../../modules/shell
    ../../modules/sudo
    ../../modules/system
    ../../modules/tailscale
    ../../modules/user
    ## TODO: Figure out voxtype for macos
    # ../../modules/voxtype
    ../../modules/window-manager
    ../../modules/browsers/zen
    ../../modules/1password

  ];

  specialArgs = { inherit inputs device-conf lib; };
}
