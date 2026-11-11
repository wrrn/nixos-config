{ pkgs, ... }:
{
  # Bound in dotfiles' niri/.config/niri/binds.kdl.
  environment.systemPackages = [ pkgs.wl-kbptr ];
}
