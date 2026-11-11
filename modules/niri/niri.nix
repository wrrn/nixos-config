{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = [
    pkgs.brightnessctl
    pkgs.playerctl
    pkgs.unstable.nirius
  ];

  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
    useNautilus = true;
  };

  services.iio-niri = {
    enable = true;
    extraArgs = [
      "--monitor"
      "eDP-1"
    ];
  };

  services.upower = {
    enable = true;
  };

  home-manager.users.${username} = {
    wrrn.dotfiles.niri.enable = true;

    programs.fuzzel = {
      enable = true;
    };
  };
}
