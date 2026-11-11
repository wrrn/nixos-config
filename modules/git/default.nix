{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{
  environment.systemPackages = with pkgs; [
    git
    delta
#    git-machete
    difftastic

    hut # Not really git related, but related to a forge.
  ];

  home-manager.users.${username}.wrrn.dotfiles.git.enable = true;
}
