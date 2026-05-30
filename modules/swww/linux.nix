{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  wallpaper = ./wallpaper.jpg;
in
{
  home-manager.users.${username} = {
    home.packages = [ pkgs.swww ];

    systemd.user.services = {
      swww-daemon = {
        Unit = {
          Description = "swww wallpaper daemon";
          PartOf = [ "graphical-session.target" ];
          After = [
            "graphical-session.target"
            "wayland-ready.service"
          ];
          Wants = [ "wayland-ready.service" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.swww}/bin/swww-daemon";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      swww-wallpaper = {
        Unit = {
          Description = "Set swww wallpaper";
          PartOf = [ "graphical-session.target" ];
          After = [ "swww-daemon.service" ];
          Requires = [ "swww-daemon.service" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.swww}/bin/swww img ${wallpaper}";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
