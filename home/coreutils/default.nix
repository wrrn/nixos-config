{pkgs, config, ...}: {
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
  ];

  programs = {
    fish = {
      enable = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
