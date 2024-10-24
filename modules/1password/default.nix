{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.device-conf) username;

in
{
  imports = [
    ./linux.nix
    ./darwin.nix
  ];
}
