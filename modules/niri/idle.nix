{
  device-conf,
  config,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{

  home-manager.users.${username} = {

    programs.swaylock = {
      enable = true;
      package = (
        pkgs.swaylock-effects.overrideAttrs (
          final: prev: { buildInputs = prev.buildInputs ++ [ pkgs.wayland-scanner ]; }
        )
      );
    };

    services.swayidle.enable = true;

    wrrn.dotfiles.swayidle.enable = true;
  };

}
