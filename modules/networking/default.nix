{ config, pkgs, ... }:
{
  imports = [
    ./dnsmasq.nix
  ];

  networking.nameservers = [ "127.0.0.1" ];
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
