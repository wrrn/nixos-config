{ config, pkgs, ... }:
let
  inherit (config.device-conf) username;
in
{
  imports = [
    ./bat.nix
    ./darwin.nix
    ./fish.nix
    ./linux.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
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
      zig
    ];

    programs.zoxide.enable = true;
  };
}
