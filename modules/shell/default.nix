{
  device-conf,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;

  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
  platformModule = lib.systemModule {
    linux = ./linux.nix;
    darwin = ./darwin.nix;
  };
in
{
  imports = [
    ./bat.nix
    ./fish.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    platformModule
  ];

  environment.systemPackages = with pkgs; [
    coreutils-full
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
    ## mise
    ripgrep
    tree
    vim
    zoxide
    bazelisk
    gmailctl
    jsonnet
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      wrrnpkgs.claude-code
      wrrnpkgs.pi
      dasht
      unstable.devenv
      grpcurl
      htop
      # jrnl
      k9s
      kubectl
      minikube
      mkcert
      nix-update
      nixfmt-rfc-style
      opencode
      pgcli
      pkgs.nodePackages_latest.prettier
      rsync
      shellcheck
      shfmt
      stow
      tree-sitter
      xh
      yq-go
      yt-dlp
      zig
    ];

    programs.zoxide.enable = true;
  };
}
