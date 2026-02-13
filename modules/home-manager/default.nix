{
  device-conf,
  pkgs,
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
    backupFileExtension = ".bak";
    backupCommand = "${pkgs.trash-cli}/bin/trash";
  };

  home-manager.users.${username}.home.stateVersion = home-manager.stateVersion;
}
