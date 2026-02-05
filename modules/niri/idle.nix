{
  device-conf,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (inputs) dotfiles;
in
{
  nixpkgs.overlays = [
    dotfiles.overlays.default
  ];

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

    home.file.dot-swayidle = {
      source = "${pkgs.dotfiles.swayidle}/.config/swayidle";
      target = ".config/swayidle";
      recursive = true;
    };
  };

}
