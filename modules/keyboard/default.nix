{ config, pkgs, ... }:
let
  inherit (config.device-conf) username;
in
{
  imports = [
    ./linux.nix
    ./darwin.nix
  ];

  home-manager.users.${username}.home.packages = [
    pkgs.qmk
  ];

}
