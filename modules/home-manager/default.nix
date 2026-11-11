{
  device-conf,
  inputs,
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

    # wrrn.dotfiles.<package>.enable links a dotfiles package into $HOME.
    # modules/dotfiles points the links at the working clone.
    sharedModules = [ inputs.dotfiles.homeManagerModules.default ];
  };

  home-manager.users.${username}.home.stateVersion = home-manager.stateVersion;
}
