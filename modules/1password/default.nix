{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs = {
    _1password = {
      enable = true;
      package = pkgs.unstable._1password-cli;
      };
    _1password-gui = {
      enable = true;
      package = pkgs.unstable._1password-gui;
      };
  };
}
