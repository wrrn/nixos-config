{ pkgs, lib, ... }:
let
  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = ./darwin.nix;
  };
in
{
  # Platform dispatch: on macOS the GUI Tailscale.app owns the daemon, so we
  # must NOT also run nix-darwin's `services.tailscale` (two daemons fight over
  # the utun interface and the MagicDNS resolver at 100.100.100.100, breaking
  # peer name resolution). On Linux the native service is the right choice.
  imports = [ module ];
}
