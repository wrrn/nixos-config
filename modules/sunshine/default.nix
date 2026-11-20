# Sunshine game streaming on niri.
#
# Sunshine mirrors a physical niri output to Moonlight, captured with
# wlr-screencopy. The stream uses that output's resolution and refresh rate,
# not the client's, and shows whatever the output shows.
#
# Requires ../niri.
{
  config,
  device-conf,
  ...
}:
let
  # niri output to stream. Sunshine's wlr capture matches `output_name`
  # against the xdg_output name.
  outputName = "eDP-1";

  # Only accept Moonlight connections over Tailscale. Sunshine on a laptop
  # that joins public Wi-Fi shouldn't listen on every interface.
  streamingInterface = "tailscale0";

  # Sunshine's port layout, offset from its base port. Matches the upstream
  # NixOS module's `openFirewall`.
  basePort = config.services.sunshine.settings.port;
  offsets = map (offset: basePort + offset);
in
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    # niri supports wlr-screencopy, which doesn't need CAP_SYS_ADMIN the way
    # KMS capture does.
    capSysAdmin = false;
    openFirewall = false;

    settings = {
      sunshine_name = device-conf.hostname;
      capture = "wlr";
      output_name = outputName;
    };

    applications.apps = [
      {
        name = "Desktop";
        image-path = "desktop.png";
        auto-detach = "true";
      }
    ];
  };

  networking.firewall.interfaces.${streamingInterface} = {
    allowedTCPPorts = offsets [
      (-5)
      0
      1
      21
    ];
    allowedUDPPorts = offsets [
      9
      10
      11
      13
      21
    ];
  };
}
