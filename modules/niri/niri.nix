{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (inputs) dotfiles niri;
in
{
  nixpkgs.overlays = [
    # niri.overlays.niri
    dotfiles.overlays.default
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = [
    pkgs.brightnessctl
    pkgs.playerctl
    pkgs.wl-kbptr
  ];

  programs.niri.enable = true;
  services.iio-niri = {
    enable = true;
    extraArgs = [ "--monitor" "eDP-1" ];
  };

  services.upower = {
    enable = true;
  };

  home-manager.users.${username} = {
    home.file.dot-niri = {
      source = "${pkgs.dotfiles.niri}/.config/niri";
      target = ".config/niri";
      recursive = true;
    };

    programs.fuzzel = {
      enable = true;
    };
  };
}
