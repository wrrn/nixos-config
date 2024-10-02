{ config, ... }:
let
  inherit (config.build-conf) username displayName;
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = displayName;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
};
