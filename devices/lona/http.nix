{ ... }:
{
  # Allow inbound HTTP/HTTPS.
  #
  # NixOS enables `networking.firewall` by default and drops everything
  # inbound that isn't explicitly allowed, so a web server listening on
  # 0.0.0.0:80 is still unreachable from other hosts until the port is
  # opened here.
  #
  # If you only ever need this over Tailscale, prefer scoping it to the
  # tailnet interface instead of opening it on every interface:
  #
  #   networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
