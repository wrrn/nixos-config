{
  pkgs,
  device-conf,
  inputs,
  lib,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${system};
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

    home.file.dot-waybar = {
      source = "${dotfiles.waybar}/.config/waybar";
      target = ".config/waybar";
      recursive = true;
    };
  };
}
