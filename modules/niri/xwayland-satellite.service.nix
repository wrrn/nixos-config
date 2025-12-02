{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;
in
{
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    xwayland
  ];

  # home-manager.users.${username}.systemd.user = {
  #   enable = true;
  #   services.xwayland-satellite = {
  #     Unit = {
  #       Description = "Xwayland outside your Wayland";
  #     };

  #     Install = {
  #       WantedBy = [ "graphical-session.target" ];
  #       BindsTo = [ "graphical-session.target" ];
  #       PartOf = [ "graphical-session.target" ];
  #       After = [ "graphical-session.target" ];
  #       Requisite = [ "graphical-session.target" ];

  #     };

  #     Service = {
  #       Type = "notify";
  #       NotifyAccess = "all";
  #       ExecStart = "/${pkgs.xwayland-satellite}/bin/xwayland-satellite";
  #       StandardOutput = "journal";

  #       Restart = "on-failure";
  #       RestartSec = "1s";
  #     };
  #   };
  # };
}
