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
  environment.systemPackages = with pkgs; [
    git
    delta
    git-machete
    difftastic
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
