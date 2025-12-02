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

  home-manager.users.${username}.home.packages = [ pkgs.zoom-us ];
}
