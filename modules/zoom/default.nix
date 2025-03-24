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

  home-manager.users.${username}.home.packages = [ pkgs.zoom-us ];
}
