{
  pkgs,
  device-conf,
  lib,
  ...
}:
let
  inherit (device-conf) username;
in
{

  home-manager.users.${username} = {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };

    systemd.user.services.waybar.Unit = {
      Wants = [
        "wayland-ready.service"
      ];
      After = [
        "wayland-ready.service"
        "niri.service"
      ];
      ConditionEnvironment = lib.mkForce [ ];
    };

    wrrn.dotfiles.waybar.enable = true;
  };
}
