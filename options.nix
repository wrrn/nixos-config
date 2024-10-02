{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) nullOr attrsOf str;
in
{
  options.conf = {
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
  };
}
