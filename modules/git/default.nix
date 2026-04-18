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
in
{
  environment.systemPackages = with pkgs; [
    git
    delta
#    git-machete
    difftastic

    hut # Not really git related, but related to a forge.
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
