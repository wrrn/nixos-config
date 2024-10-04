{ config, pkgs, ... }:
let
  inherit (config.device-conf) username;
in
{
  imports = [
    ./fish.nix
    ./starship.nix
    ./bat.nix
    ./linux.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    curl
    ripgrep
    gnumake
    zoxide
    gnugrep
    coreutils-full
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      alacritty
      asdf
      bash
      bash
      bat
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
      go
      gofumpt
      golangci-lint
      grpcurl
      httpie
      hwatch
      jq
      jrnl
      k9s
      kubectl
      minikube
      mkcert
      mosh
      nixfmt-rfc-style
      pgcli
      ripgrep
      rsync
      shellcheck
      shfmt
      stow
      terminal-notifier
      tmux
      tree
      tree-sitter
      yq-go
      yt-dlp
      zoxide
    ];

    programs.zoxide.enable = true;
  };
}
