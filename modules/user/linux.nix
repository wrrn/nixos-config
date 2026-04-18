{ device-conf, ... }:
let
  inherit (device-conf) username displayName;
in
{
  users.users.${username} = {
    home = "/home/${username}";
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "plugdev"
      "video"
    ];
  };
}
