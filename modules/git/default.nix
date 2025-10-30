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
  environment.systemPackages = with pkgs; [
    git
    delta
    git-machete
    difftastic

    hut # Not really git related, but related to a forge.
  ];

  home-manager.users.${username}.home.file = {
    ".gitconfig" = {
      source = "${pkgs.dotfiles.git}/.gitconfig";
    };
    ".gitattributes" = {
      source = "${pkgs.dotfiles.git}/.gitattributes";
    };
  };
}
