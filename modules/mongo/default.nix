{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{
  nixpkgs.overlays = [ inputs.wrrnpkgs.overlays.default ];
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      mongosh
      wrrn.mongodb-atlas-cli
      mongodb-tools
      mongodb-compass
    ];
  };
}
