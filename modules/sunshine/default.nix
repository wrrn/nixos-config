# Sunshine game streaming on niri.
#
# Sunshine mirrors a physical niri output to Moonlight, captured with
# wlr-screencopy. The stream uses that output's resolution and refresh rate,
# not the client's, and shows whatever the output shows.
#
# Requires ../niri.
{ device-conf, ... }:
let
  # niri output to stream. Sunshine's wlr capture matches `output_name`
  # against the xdg_output name.
  outputName = "eDP-1";
in
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    # niri supports wlr-screencopy, which doesn't need CAP_SYS_ADMIN the way
    # KMS capture does.
    capSysAdmin = false;
    # Open Sunshine's ports on every interface.
    # TODO: Scope this to tailscale0 before using Sunshine on public Wi-Fi.
    openFirewall = true;

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
}
