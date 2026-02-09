{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      cliphist
      wl-clipboard
      xdg-utils
    ];

    services.cliphist = {
      enable = true;
      allowImages = true;
      clipboardPackage = pkgs.wl-clipboard;
    };

    systemd.user.services.cliphist.Unit = {
      Wants = [ "wayland-ready.service" ];
      After = [ "wayland-ready.service" ];
    };

    systemd.user.services.cliphist-images.Unit = {
      Wants = [ "wayland-ready.service" ];
      After = [ "wayland-ready.service" ];
    };
  };
}
