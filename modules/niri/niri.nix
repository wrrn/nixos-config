{
  inputs,
  pkgs,
  username,
  ...
}:
{

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.upower = {
    enable = true;
  };

  services.logind = {
    powerKey = "poweroff";
    lidSwitch = "suspend";
  };

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      swayidle
      kitty
    ];

    programs.fuzzel = {
      enable = true;
    };

    programs.swaylock = {
      enable = true;
      package = (
        pkgs.swaylock-effects.overrideAttrs (
          final: prev: { buildInputs = prev.buildInputs ++ [ pkgs.wayland-scanner ]; }
        )
      );
    };

    services.mako = {
      enable = true;
    };
  };

}
