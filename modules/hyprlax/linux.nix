{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  wallpaper = ./wallpaper.jpg;

  configFile = pkgs.writeText "hyprlax.toml" ''
    [global]
    duration = 0.7
    easing = "circ"

    [[global.layers]]
    path = "${wallpaper}"
    fit = "cover"
    align = { x = 0.5, y = 0.5 }
  '';
in
{
  home-manager.users.${username} = {
    home.packages = [ pkgs.unstable.hyprlax ];

    systemd.user.services.hyprlax = {
      Unit = {
        Description = "hyprlax parallax wallpaper daemon";
        PartOf = [ "graphical-session.target" ];
        After = [
          "graphical-session.target"
          "wayland-ready.service"
        ];
        Wants = [ "wayland-ready.service" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.unstable.hyprlax}/bin/hyprlax --config ${configFile}";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
