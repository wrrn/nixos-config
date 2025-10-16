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
  services.sketchybar = {
    enable = true;
    extraPackages = [
      lua5_4_compat
      sbarlua
    ];
  };

  nixpkgs.overlays = [ dotfiles.overlays.default ];
  home-manager.users.${username} = {
    home.packages = [
      lua5_4_compat # We use lua to configure it
      sbarlua # The lua library that we use to configure it
    ];

    home.file.dot-sketchybar = {
      target = ".config/sketchybar";
      source = "${pkgs.dotfiles.sketchybar}/.config/sketchybar";
      recursive = true;
    };
  };
}
