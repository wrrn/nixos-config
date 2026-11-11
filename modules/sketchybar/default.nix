{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
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

    wrrn.dotfiles.sketchybar.enable = true;
  };
}
