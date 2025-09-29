{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (config.device-conf) username;
in
{
  nixpkgs.overlays = [ inputs.wrrnpkgs.overlays.macApps ];
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      mongosh
      wrrn.mongodb-atlas-cli
      mongodb-tools
      mongodb-compass
    ];
  };
}
