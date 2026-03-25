{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      mongosh
      wrrnpkgs.mongodb-atlas-cli
      mongodb-tools
      mongodb-compass
    ];
  };
}
