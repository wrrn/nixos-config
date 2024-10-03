{ config, pkgs, ... }:
let
  inherit (config.device-conf) hostname;
in
{
  imports = [
    ./dnsmasq.nix
  ];

  networking.hostName = hostname;
  networking.stevenblack = {
    enable = true;
    block = [
      "fakenews"
      "gambling"
      "porn"
      "social"
    ];
  };

  # Enable networking
  networking.networkmanager.enable = true;
}
