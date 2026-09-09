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
    darwin = ./darwin.nix;
  };
in
{
  imports = [ module ];

  home-manager.users.${username} = {
    programs.qutebrowser = {
      enable = true;
      package = pkgs.unstable.qutebrowser;
      loadAutoconfig = true;
    };
  };
}
