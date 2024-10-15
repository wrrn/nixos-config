{
  lib,
  pkgs,
  options,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkIf optionalAttrs;

  modules = ([

    (optionalAttrs (options ? networking.networkmanager.enable) {
      networking.networkmanager.enable = true;
    })

    (optionalAttrs (options ? networking.stevenblack) {
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

    (optionalAttrs (options ? networking.nameservers) {
      networking.nameservers = [ "127.0.0.1" ];
    })
  ]);

in
mkIf isLinux (lib.foldl lib.attrsets.recursiveUpdate { } modules)
