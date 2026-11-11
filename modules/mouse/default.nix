# Keyboard-driven pointer control.
#
# macOS uses Neru (https://github.com/y3owk1n/neru). Linux uses wl-kbptr.
{ lib, ... }:
{
  imports = [
    (lib.systemModule {
      linux = ./linux.nix;
      darwin = ./darwin.nix;
    })
  ];
}
