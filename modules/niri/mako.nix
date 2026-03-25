{
  pkgs,
  device-conf,
  inputs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${system};
in
{

  home-manager.users.${username} = {
    services.mako.enable = true;

    home.file.dot-mako = {
      source = "${dotfiles.mako}/.config/mako";
      target = ".config/mako";
      recursive = true;
    };
  };
}
