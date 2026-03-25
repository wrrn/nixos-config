{
  device-conf,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username home-manager;
in
{
  imports = [
    (lib.systemModule { darwin = ./darwin.nix; linux = { }; })
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = ".bak";
    backupCommand = "${pkgs.trash-cli}/bin/trash";
  };

  home-manager.users.${username}.home.stateVersion = home-manager.stateVersion;
}
