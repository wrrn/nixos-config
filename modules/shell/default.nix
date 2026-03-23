{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{

  nixpkgs.overlays = [ inputs.wrrnpkgs.overlays.default ];

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
    mise
    ripgrep
    tree
    vim
    zoxide
    bazelisk
    gmailctl
    jsonnet
  ];

  nixpkgs.config.allowUnfree = true;
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      unstable.claude-code
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
