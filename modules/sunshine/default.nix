# Sunshine game streaming on niri, using headless virtual outputs.
#
# When a Moonlight client starts a session, a prep command creates a niri
# virtual output named after `outputName` at the client's resolution and
# frame rate. Sunshine captures that output with wlr-screencopy. When the
# session ends, the virtual output is removed and niri moves its workspaces
# back to the physical displays.
#
# Stock niri can't create virtual outputs yet, so this module builds niri from
# niri-wm/niri#3800 ("Add virtual output support"). Drop the override once
# that PR lands in a release.
#
# Requires ../niri.
{
  config,
  device-conf,
  lib,
  pkgs,
  ...
}:
let
  # Name of the virtual output created for each streaming session. Sunshine's
  # wlr capture matches `output_name` against the xdg_output name.
  outputName = "sunshine";

  # Only accept Moonlight connections over Tailscale. Sunshine on a laptop
  # that joins public Wi-Fi shouldn't listen on every interface.
  streamingInterface = "tailscale0";

  # niri with virtual output support (niri-wm/niri#3800).
  niri = pkgs.unstable.niri.overrideAttrs (
    finalAttrs: prev: {
      version = "26.04-unstable-2026-11-08-virtual-outputs";

      src = pkgs.fetchFromGitHub {
        owner = "willybarret";
        repo = "niri";
        rev = "7fd585dd44ed67644977dd9561bb6e8b3837f8f7"; # wip/virtual-outputs
        hash = "sha256-OWF03QF62Q8HJ3fCme3I3GX7dKX9YU+JD7bhTiIzfQ4=";
      };

      cargoDeps = pkgs.unstable.rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
        hash = "sha256-Yqvambc4F7PdGkGxrxp5xD6PqAEAWmMgqOYZRY+TIBA=";
      };

      # Upstream CI runs the test suite; skip it here to keep rebuilds short.
      doCheck = false;
      # versionCheckHook expects `niri --version` to print `version`, which
      # isn't true for an unreleased build.
      doInstallCheck = false;
    }
  );

  virtualDisplay = pkgs.writeShellApplication {
    name = "sunshine-virtual-display";
    runtimeInputs = [
      niri
      pkgs.coreutils
      pkgs.systemd
    ];
    text = ''
      output=${lib.escapeShellArg outputName}
      inhibitUnit=sunshine-inhibit-sleep

      # Sunshine inherits NIRI_SOCKET from the systemd user environment.
      # Fall back to the socket in the runtime dir if it's missing.
      if [ -z "''${NIRI_SOCKET:-}" ]; then
        for socket in "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"/niri.wayland-*.sock; do
          [ -S "$socket" ] && export NIRI_SOCKET="$socket" && break
        done
      fi

      start() {
        width="''${SUNSHINE_CLIENT_WIDTH:-1920}"
        height="''${SUNSHINE_CLIENT_HEIGHT:-1080}"
        fps="''${SUNSHINE_CLIENT_FPS:-60}"

        # Clear an output left behind by a session that didn't clean up.
        niri msg remove-virtual-output "$output" >/dev/null 2>&1 || true

        niri msg create-virtual-output \
          --name "$output" \
          --width "$width" \
          --height "$height" \
          --refresh-rate "$fps"

        # Put focus (and the next window opened) on the streamed output.
        niri msg action focus-monitor "$output" || true

        # Keep the laptop awake with the lid closed for the whole session.
        systemctl --user stop "$inhibitUnit" >/dev/null 2>&1 || true
        systemd-run --user --collect --quiet --unit="$inhibitUnit" \
          ${pkgs.systemd}/bin/systemd-inhibit \
            --what=sleep:idle:handle-lid-switch \
            --who=Sunshine \
            --why="Moonlight streaming session" \
            ${pkgs.coreutils}/bin/sleep infinity || true
      }

      stop() {
        systemctl --user stop "$inhibitUnit" >/dev/null 2>&1 || true
        niri msg remove-virtual-output "$output"
      }

      case "''${1:-}" in
        start) start ;;
        stop) stop ;;
        *)
          echo "usage: sunshine-virtual-display start|stop" >&2
          exit 2
          ;;
      esac
    '';
  };

  virtualDisplayPrepCmd = {
    do = "${lib.getExe virtualDisplay} start";
    undo = "${lib.getExe virtualDisplay} stop";
  };

  # Sunshine's port layout, offset from its base port. Matches the upstream
  # NixOS module's `openFirewall`.
  basePort = config.services.sunshine.settings.port;
  offsets = map (offset: basePort + offset);
in
{
  programs.niri.package = lib.mkForce niri;

  services.sunshine = {
    enable = true;
    autoStart = true;
    # KMS capture can't see virtual outputs; wlr-screencopy can, and doesn't
    # need CAP_SYS_ADMIN.
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
        prep-cmd = [ virtualDisplayPrepCmd ];
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

  environment.systemPackages = [ virtualDisplay ];
}
