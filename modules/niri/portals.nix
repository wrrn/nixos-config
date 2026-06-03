{ ... }:
{
  # The upstream xdg-desktop-portal.service only waits for dbus.service.
  # Under a standalone Wayland compositor it can be started (via D-Bus
  # activation) before the graphical-session environment has been imported,
  # leaving the portal without WAYLAND_DISPLAY and friends.
  #
  # By overriding the unit and adding graphical-session.target to its After=
  # list we guarantee the portal only starts once the full session graph is
  # ready.
  #
  # See NixOS/nixpkgs#279434
  systemd.user.services.xdg-desktop-portal.after = [ "graphical-session.target" ];
}
