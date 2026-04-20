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
    darwin = ./darwin.nix;
  };
in
{
  home-manager.users.${username}.home.packages = [
    wrrnpkgs.claude-code
    wrrnpkgs.pi
  ];
}
