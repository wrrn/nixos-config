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
    bat
    coreutils-full
    curl
    curl
    delta
    diffutils
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
    mise
    ripgrep
    tree
    vim
    zoxide
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      dasht
      grpcurl
      jrnl
      k9s
      kubectl
      minikube
      mkcert
      nix-update
      nixfmt-rfc-style
      pgcli
      rsync
      shellcheck
      shfmt
      stow
      tree-sitter
      wrrn.yaak
      xh
      yq-go
      yt-dlp
      zig
    ];

    programs.zoxide.enable = true;
  };
}
