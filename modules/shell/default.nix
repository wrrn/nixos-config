{ config, pkgs, ... }:
let
  inherit (config.device-conf) username;
in
{
  imports = [
    ./fish.nix
    ./starship.nix
    ./bat.nix
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      bat
      ripgrep
      yq-go
      fd
      eza
      zoxide
      pgcli
      minikube
      kubectl
      rsync
      nixfmt-rfc-style
      difftastic
      delta
      direnv
    ];

    programs.zoxide.enable = true;
  };
}
