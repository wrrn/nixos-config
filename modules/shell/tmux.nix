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

  home-manager.users.${username} = {
    home.packages = [ pkgs.tmux ];
    home.file.dot-tmux = {
      source = "${pkgs.dotfiles.tmux}/.config/tmux";
      target = ".config/tmux";
      recursive = true;
    };
  };
}
