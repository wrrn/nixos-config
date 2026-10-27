{
  lib,
  pkgs,
  ...
}:
let
  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = ./darwin.nix;
  };
in
{
  imports = [ module ];

  programs = {
    _1password = {
      enable = true;
      package = pkgs._1password-cli;
    };
    _1password-gui = {
      enable = true;
      package = pkgs._1password-gui;
    };
  };
}
