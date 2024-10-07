{ config, pkgs, ... }:
let
  inherit (config.device-conf) hostname;
in
{
  imports = [
    ./linux.nix
    ./darwin.nix
  ];

  networking.hostName = hostname;
}
