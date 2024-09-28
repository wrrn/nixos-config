{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    bat
    ripgrep
    yq-go
    fd
    eza
    zoxide
    wezterm
    pgcli
    minikube
    kubectl
    rsync
    nixfmt-rfc-style
    difftastic
    delta
    direnv
  ];

  programs = {
    fish = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
