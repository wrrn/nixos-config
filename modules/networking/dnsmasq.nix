{ config, pkgs, ... }:
let
  addresses = import ./blocked-addresses.nix;
  cname = builtins.map (addr: "${addr},localhost") addresses;
in
{

  # Proxy all DNS requests through dnsmasq.
  networking.nameservers = [ "127.0.0.1" ];
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      inherit cname;
      server = [
        "1.1.1.3"
        "1.0.0.3"
      ];
    };
  };
}
