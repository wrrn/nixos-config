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
    pkgs.wl-kbptr
  ];

  programs.niri = {
    enable = true;
    # package = pkgs.niri-stable;
  };

  services.upower = {
    enable = true;
  };

  services.logind.settings.Login = {
    HandlePowerKey = "poweroff";
    HandleLidSwitch = "suspend";
  };

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      swayidle
    ];

    home.file.dot-niri = {
      source = "${pkgs.dotfiles.niri}/.config/niri";
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
