{ inputs, pkgs, ... }:
{
  imports = [
    ./niri.nix
    ./waybar.nix
    ./mako.nix
    ./idle.nix
    ./polkit.nix
    ./wayland-ready.nix
    ./xwayland-satellite.service.nix
    ./theme.nix
  ];

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
  systemd.user.services.xdg-desktop-portal = {
    description = "Portal service";
    partOf = [ "graphical-session.target" ];
    requires = [ "dbus.service" ];
    after = [ "dbus.service" "graphical-session.target" ];
    serviceConfig = {
      Type = "dbus";
      BusName = "org.freedesktop.portal.Desktop";
      ExecStart = "${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal";
      Slice = "session.slice";
    };
  };

}
