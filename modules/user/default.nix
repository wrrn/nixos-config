{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.device-conf) username displayName;
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} =
    {
      description = displayName;
      home = "/Users/${username}";
    }
    // lib.optionalAttrs (pkgs.stdenv.isLinux) {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
}
