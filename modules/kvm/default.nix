{
  device-conf,
  inputs,
  lib,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = { };
  };
in
{
  imports = [ module ];
  home-manager.users.${username} = {
    imports = [ inputs.wrrnpkgs.homeManagerModules.lan-mouse ];
    programs.lan-mouse = {
      enable = true;
      package = wrrnpkgs.lan-mouse;
    };
  };
}
