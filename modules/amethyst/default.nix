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
  nixpkgs.overlays = [ inputs.wrrnpkgs.overlay.macApps ];
  home-manager.users.${username} = {
    home.packages = [ pkgs.amethyst ];
    home.file.dot-amethyst = {
      source = "${dotfiles.amethyst}/.amethyst.yml";
      target = ".amethyst.yml";
    };
  };
}
