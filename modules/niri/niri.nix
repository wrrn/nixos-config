{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles;
  inherit (config.device-conf) username;
in
{

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
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

    home.file.dot-niri = {
      source = "${dotfiles.niri}/.config/niri";
      target = ".config/niri";
      recursive = true;
    };

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
