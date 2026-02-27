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
    ../../modules/gcp-image
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

    # Override google-compute-config defaults that conflict with
    # traditional SSH key auth via the guest agent.
    # Enable serial getty for debugging via `gcloud compute connect-to-serial-port`.
    {
      security.googleOsLogin.enable = lib.mkForce false;
      systemd.services."serial-getty@ttyS0".enable = true;
    }

    {
      fileSystems."/tmp/nixbuild" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [ "defaults" "mode=755" "size=50%" ];
      };
    }
  ];

  specialArgs = {
    inherit inputs device-conf lib;
  };
}
