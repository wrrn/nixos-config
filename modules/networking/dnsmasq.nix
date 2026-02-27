{
  lib,
  pkgs,
  options,
  ...
}:
let
  inherit (lib) optionalAttrs mkIf foldl;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (pkgs.stdenv) isLinux;
  addresses = import ./blocked-addresses.nix;
  cname = builtins.map (addr: "${addr},localhost") addresses;
  modules = [
    {
      services.dnsmasq = {
        enable = true;
      };
    }

    (optionalAttrs (options ? services.dnsmasq.settings) {
      services.dnsmasq.settings = {
        inherit cname;
        listen-address = "127.0.0.1";
        bind-interfaces = true;
        server = [
          "1.1.1.3"
          "1.0.0.3"
        ];
      };
    })

    (optionalAttrs (options ? services.dnsmasq.alwaysKeepRunning) {
      services.dnsmasq.alwaysKeepRunning = true;
    })

  ];
in
mkIf isLinux (foldl recursiveUpdate { } modules)
