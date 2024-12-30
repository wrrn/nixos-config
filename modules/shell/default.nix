{ config, pkgs, ... }:
let
  inherit (config.device-conf) username;
in
{
  imports = [
    ./fish.nix
    ./starship.nix
    ./bat.nix
    ./tmux.nix
    ./linux.nix
    ./darwin.nix
  ];

  environment.systemPackages = with pkgs; [
    asdf-vm
    bat
    coreutils-full
    curl
    curl
    delta
    diffutils
    direnv
    eza
    fd
    fzf
    gnugrep
    gnumake
    gnused
    gnutar
    gnutls
    httpie
    hwatch
    jq
    ripgrep
    tree
    vim
    zoxide
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      go
      gofumpt
      golangci-lint
      gotools
      delve
      gdlv

      dasht
      grpcurl
      jrnl
      k9s
      kubectl
      minikube
      mkcert
      # mosh
      nixfmt-rfc-style
      pgcli
      rsync
      shellcheck
      shfmt
      stow
      tree-sitter
      yq-go
      yt-dlp
    ];

    programs.zoxide.enable = true;
  };
}
