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
  home-manager.users.${username}.home.packages = [ pkgs.ghostty ];
}
