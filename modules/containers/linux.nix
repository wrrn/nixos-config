{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) optionalAttrs;
in
{
  # config = optionalAttrs isLinux {
  # virtualisation.podman = {
  # enable = true;
  # dockerCompat = true;
  # };
  # };
}
