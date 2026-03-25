{
  device-conf,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = { };
  };
in
{
  imports = [ module ];
  home-manager.users.${username}.programs.bluetuith.enable = true;
}
