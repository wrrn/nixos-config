{ device-conf, ... }:
let
  inherit (device-conf) username;
in
{
  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Update the systemd file override the After and Want so that it starts after wayland is up.
  # Note: This only works if the wayland-ready service has succeeded.
  home-manager.users.${username}.home.file.blueman-systemd-override = {
    target = ".config/systemd/user/app-blueman@autostart.service.d/override.conf";
    text = ''
      [Unit]
      After=wayland-ready.service
      Wants=wayland-ready.service
    '';
  };
}
