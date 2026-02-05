{
  pkgs,
  device-conf,
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
    services.mako.enable = true;

    home.file.dot-mako = {
      source = "${pkgs.dotfiles.mako}/.config/mako";
      target = ".config/mako";
      recursive = true;
    };
  };
}
