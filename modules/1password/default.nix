{ config, pkgs, ... }:
let
  inherit (config.device-conf) username;
in
{
  nixpkgs.config.allowUnfree = true;
  home-manager.users.${username} = {
    home.packages = [
      pkgs._1password
      pkgs._1password-gui
    ];
  };
}
