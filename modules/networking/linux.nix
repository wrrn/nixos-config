{
  lib,
  options,
  ...
}:
{
  networking.networkmanager.enable = true;

  networking.stevenblack = {
    enable = true;
    block = [
      "fakenews"
      "gambling"
      "porn"
      "social"
    ];
  };

  networking.nameservers = [ "127.0.0.1" ];

  wrrn.hosts.enable = true;
}
