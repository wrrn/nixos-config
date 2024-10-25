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
  nixpkgs.overlays = [ dotfiles.overlays.default ];

  home-manager.users.${username} = {
    home.packages = [ pkgs.bat ];
    home.file.dot-bat = {
      source = "${pkgs.dotfiles.bat}/.config/bat";
      target = ".config/bat";
      recursive = true;
    };
  };
}
