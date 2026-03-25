{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${system};
in
{
  home-manager.users.${username} = {
    home.packages = [ pkgs.bat ];
    home.file.dot-bat = {
      source = "${dotfiles.bat}/.config/bat";
      target = ".config/bat";
      recursive = true;
    };
  };
}
