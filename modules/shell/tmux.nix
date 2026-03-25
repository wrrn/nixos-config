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
  home-manager.users.${username} = {
    home.packages = [ pkgs.tmux ];
    home.file.dot-tmux = {
      source = "${dotfiles.tmux}/.config/tmux";
      target = ".config/tmux";
      recursive = true;
    };
  };
}
