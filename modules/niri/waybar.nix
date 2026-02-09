{
  pkgs,
  device-conf,
  inputs,
  lib,
  ...
}:
let
  inherit (device-conf) username;
  inherit (inputs) dotfiles;
in
{
  nixpkgs.overlays = [
    # niri.overlays.niri
    dotfiles.overlays.default
  ];

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
      source = "${pkgs.dotfiles.waybar}/.config/waybar";
      target = ".config/waybar";
      recursive = true;
    };
  };
}
