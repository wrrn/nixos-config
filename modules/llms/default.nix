{
  device-conf,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = ./darwin.nix;
  };
in
{
  imports = [ module ];
}
