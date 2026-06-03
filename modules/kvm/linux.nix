{ device-conf, ... }:
{
  home-manager.users.${device-conf.username}.programs.lan-mouse.systemd = true;
  networking.firewall.allowedUDPPorts = [ 4242 ];
}
