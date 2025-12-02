{
  device-conf,
  ...
}:
let
  inherit (device-conf) username home-manager;
in
{
  imports = [
    ./darwin.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };

  home-manager.users.${username}.home.stateVersion = home-manager.stateVersion;
}
