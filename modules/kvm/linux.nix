_: {
  programs.lan-mouse.systemd = true;
  networking.firewall.allowedUDPPorts = [ 4242 ];
}
