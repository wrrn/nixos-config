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
  services.sketchybar = {
    enable = true;
    extraPackages = [
      pkgs.lua5_4_compat
      pkgs.sbarlua
    ];
  };

  home-manager.users.${username} = {
    home.packages = [
      pkgs.lua5_4_compat # We use lua to configure it
      pkgs.sbarlua # The lua library that we use to configure it
    ];

    home.file.dot-sketchybar = {
      target = ".config/sketchybar";
      source = "${dotfiles.sketchybar}/.config/sketchybar";
      recursive = true;
    };
  };
}
