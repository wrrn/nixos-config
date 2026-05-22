{ inputs, pkgs, ... }:
let
  overrides = {
    _1password = pkgs.master._1password-cli;
    _1password-cli = pkgs.master._1password-cli;
    _1password-gui = pkgs.master._1password-gui;
  };

  fixedPackageNames = pkgs.lib.concatStringsSep ", " (pkgs.lib.attrNames overrides);

  overlay = final: prev: overrides;
in
{
  nixpkgs.overlays = [ overlay ];
  warnings = [
    "The following packages are being fixed: ${fixedPackageNames}"
  ];
}
