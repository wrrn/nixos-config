{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username} = {
    home.packages = [ pkgs.tmux ];
    wrrn.dotfiles.tmux.enable = true;
  };
}
