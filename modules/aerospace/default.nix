{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles;
  inherit (device-conf) username;
in
{

  nixpkgs.overlays = [ dotfiles.overlays.default ];

  home-manager.users.${username} = {
    programs.aerospace = {
      enable = true;
      package = pkgs.unstable.aerospace;
      launchd.enable = true;
    };

    home.file.dot-aerospace = {
      source = "${pkgs.dotfiles.aerospace}/.config/aerospace";
      target = ".config/aerospace";
      recursive = true;
    };
  };

}
