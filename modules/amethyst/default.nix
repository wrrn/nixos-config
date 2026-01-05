{
  device-conf,
  inputs,
  pkgs,
  ...
}:

let
  inherit (inputs) dotfiles wrrnpkgs;
  inherit (device-conf) username;
in
{
  nixpkgs.overlays = [
    wrrnpkgs.overlays.default
    dotfiles.overlays.default
  ];

  home-manager.users.${username} = {
    home.packages = [ pkgs.wrrn.amethyst ];
    home.file.dot-amethyst = {
      source = "${pkgs.dotfiles.amethyst}/.amethyst.yml";
      target = ".amethyst.yml";
    };
  };
}
