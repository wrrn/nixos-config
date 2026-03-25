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
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
in
{
  home-manager.users.${username} = {
    home.packages = [ wrrnpkgs.amethyst ];
    home.file.dot-amethyst = {
      source = "${dotfiles.amethyst}/.amethyst.yml";
      target = ".amethyst.yml";
    };
  };
}
