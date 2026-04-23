{
  device-conf,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) hostname;
in
{
  imports = [
    (lib.systemModule {
      linux = ./linux.nix;
      darwin = ./darwin.nix;
    })
    (lib.systemModule {
      linux = ./dnsmasq.nix;
      darwin = { };
    })
  ];

  networking.hostName = hostname;
}
