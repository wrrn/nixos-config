{
  options,
  lib,
  pkgs,
  ...
}:
{
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "ctrl:nocaps";
  };

  console.useXkbConfig = true;
  services.udev.packages = [ pkgs.qmk-udev-rules ];
}
