{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (config.device-conf) username;
in
{

  nixpkgs.overlays = [ inputs.wrrnpkgs.overlays.macApps ];

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
    bazelisk
    gmailctl
    jsonnet
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
      ## Disable this because it's currently broken on darwin.
      ## TODO: Check in a little while. 2025/09/02
      # pgcli
      pkgs.nodePackages_latest.prettier
      rsync
      shellcheck
      shfmt
      stow
      tree-sitter
      wrrn.claude-code
      # wrrn.wireman
      wrrn.yaak
      xh
      yq-go
      yt-dlp
      zig
      devenv
      opencode
    ];

    programs.zoxide.enable = true;
  };
}
