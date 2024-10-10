{ config, pkgs, ... }:
let
  inherit (config.device-conf) hostname;
in
{
  imports = [
    ./linux.nix
    ./darwin.nix
    ./dnsmasq.nix
  ];

  networking.hostName = hostname;
}
