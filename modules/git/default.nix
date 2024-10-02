{ config, pkgs, ... }:
let
  inherit (inputs) dotfiles;
  inherit (config.build-conf) username;
in
{
  environment.systemPackages = [
    pkgs.git
  ];

  home-manager.users.${username}.home.file = {
    ".gitconfig" = "${dotfiles.git}/.gitconfig";
    ".gitattributes" = "${dotfiles.git}/.gitattributes";
  };
}
