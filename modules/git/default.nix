{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles;
  inherit (config.build-conf) username;
in
{
  environment.systemPackages = [
    pkgs.git
  ];

  home-manager.users.${username}.home.file = {
    ".gitconfig" = {
      source = "${dotfiles.git}/.gitconfig";
    };
    ".gitattributes" = {
      source = "${dotfiles.git}/.gitattributes";
    };
  };
}
