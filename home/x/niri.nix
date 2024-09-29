{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  home.packages = with pkgs; [
    brightnessctl
    swaybg
    swayidle
  ];

  services.logind = {
    powerKey = "poweroff";
    lidSwitch = "suspend";
  };

  programs.fuzzel = {
    enable = true;
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
  };

  services.mako = {
    enable = true;
  };
}
