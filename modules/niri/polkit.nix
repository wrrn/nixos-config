{ device-conf, ... }:
let
  inherit (device-conf) username;
in
{
  # For adding auth when an app needs to sudo.
  security.polkit.enable = true;

  home-manager.users.${username} = {
    services.polkit-gnome.enable = true;
    systemd.user.services.polkit-gnome.Unit.After = [ "niri.service" ];
  };
}
