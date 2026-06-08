{ device-conf, ... }:
{
  home-manager.users.${device-conf.username}.programs.lan-mouse = {
    enable = true;
    Wants = [
      "wayland-ready.service"
    ];
    After = [
      "wayland-ready.service"
      "niri.service"
    ];

  };
  networking.firewall.allowedUDPPorts = [ 4242 ];
}
