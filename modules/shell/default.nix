{ username, pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./starship.nix
    ./bat.nix
  ];

  home-manager.user.${username} = {
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
