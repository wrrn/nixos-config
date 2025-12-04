{ device-conf, pkgs, ... }:
let
  inherit (device-conf) hostname;
in
{
  imports = [
    ./linux.nix
    ./darwin.nix
    ./dnsmasq.nix
  ];

  networking.hostName = hostname;
}
