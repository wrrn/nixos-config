{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;
  waylandReady = pkgs.writeShellApplication {
    name = "wayland-ready";
    runtimeInputs = [
      pkgs.systemd
      pkgs.dbus
      pkgs.coreutils
    ];
    text = builtins.readFile ./wayland-ready.sh;
  };
in
{
  home-manager.users.${username}.systemd.user = {
    paths.wayland-socket = {
      Unit.Description = "Wait for the wayland socket";
      Path = {
        PathExistsGlob = "%t/wayland-*";
        Unit = "wayland-ready.service";
      };
    };

    services.wayland-ready = {
      Unit = {
        Description = "Wait for the Wayland socket and import env";
        Before = [ "graphical-session.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${waylandReady}/bin/wayland-ready";
        Restart = "on-failure";
        RestartSec = 1;
      };

      Install.WantedBy = [ "graphical-session.target" ];

    };
  };
}
