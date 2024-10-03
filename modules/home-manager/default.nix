{ config, ... }:
let
  inherit (config.device-conf) username home-manager;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };

  home-manager.users.${username}.home.stateVersion = home-manager.stateVersion;
}
