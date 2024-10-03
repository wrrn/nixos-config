{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) nullOr attrsOf str;
in
{
  options.device-conf = {
    username = mkOption {
      type = str;
      description = "Username of the default user (single user setup).";
      default = "warren";
      example = "burt";
    };

    displayName = mkOption {
      type = str;
      description = "The name that will be displayed of the user";
      default = "Warren Harper";
      example = "Alan Taylor";
    };

    hostName = mkOption {
      type = str;
      description = "The hostname of the device.";
      default = null;
      example = "my-host";
    };

    home-manager.stateVersion = mkOption {
      type = str;
      description = "The version of the file layout for home-manager. Set this to the latest on the first install and leave it.";
      example = "24.11"
    };

    system.stateVersion = mkOption {
      type = str;
      description = "The version of the file layout for nixos/nix-darwin. Set this to the latest on the first install and leave it.";
      default = null;
      example = "24.11";
    };

    architecture = mkOption {
      type = str;
      description = "The architecture of the device.";
      default = null;
      example = "x86_64-linux";
    };
  };
}
