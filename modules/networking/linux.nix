{
  lib,
  pkgs,
  options,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkIf optionalAttrs;
in
mkIf isLinux ({
  # Enable networking
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
})
