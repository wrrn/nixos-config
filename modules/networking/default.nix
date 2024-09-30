{ config, pkgs, ... }:
{
  imports = [
    ./dnsmasq.nix
  ];

  networking.hostName = "redwall";
  networking.nameservers = [ "127.0.0.1" ];
  networking.stevenblack = {
    enable = true;
    block = [
      "fakenews"
      "gambling"
      "porn"
      # "social"
    ];
  };
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

}
