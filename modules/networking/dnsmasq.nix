{
  lib,
  options,
  ...
}:
let
  addresses = import ./blocked-addresses.nix;
  cname = builtins.map (addr: "${addr},localhost") addresses;
in
{

  services.dnsmasq = {
    enable = true;
    settings = {
      inherit cname;
      listen-address = "127.0.0.1";
      bind-interfaces = true;
      server = [
        "1.1.1.3"
        "1.0.0.3"
      ];
    };
  };

  services.dnsmasq.alwaysKeepRunning = true;
}
