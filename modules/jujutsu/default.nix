{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles;
  inherit (config.device-conf) username;
  # XXX: cargo-nextest fails to build on macOS, skip tests until the issue
  # is resolved.
  #
  # cf. https://github.com/NixOS/nixpkgs/issues/456113

  jujutsu =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.jujutsu.override {
        rustPlatform = pkgs.rustPlatform // {
          buildRustPackage = pkgs.rustPlatform.buildRustPackage.override { cargoNextestHook = null; };
        };
      }
    else
      pkgs.jujutsu;
in
{
  nixpkgs.overlays = [ dotfiles.overlays.default ];
  environment.systemPackages = [
    pkgs.difftastic # Difftool that uses AST
    pkgs.mergiraf # Merge tool that is syntax aware
    jujutsu
  ];

  home-manager.users.${username}.home.file.dot-jj = {
    target = ".config/jj";
    source = "${pkgs.dotfiles.jj}/.config/jj";
    recursive = true;
  };
}
