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
mkIf isLinux (
  optionalAttrs (options.networking ? networkmanager) ({
    # Enable networking
    networking.networkmanager.enable = true;
  })
  // optionalAttrs (options.networking ? stevenblack) ({
    networking.stevenblack = {
      enable = true;
      block = [
        "fakenews"
        "gambling"
        "porn"
        "social"
      ];
    };
  })
  // optionalAttrs (options.networking ? nameservers) ({
    networking.nameservers = [ "127.0.0.1" ];
  })
  // optionalAttrs (options ? services.dnsmasq.alwaysKeepRunning) (import ./dnsmasq.nix { })
)
