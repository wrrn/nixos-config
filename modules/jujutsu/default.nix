{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${system};
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};

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
      pkgs.unstable.jujutsu;
in
{
  environment.systemPackages = [
    pkgs.difftastic # Difftool that uses AST
    pkgs.mergiraf # Merge tool that is syntax aware
    jujutsu
    wrrnpkgs.jw
  ];

  home-manager.users.${username} = {
    programs.jujutsu = {
      enable = true;
      package = jujutsu;
      ediff = false;
    };

    home = {
      packages = [
        pkgs.difftastic
        pkgs.delta
        wrrnpkgs.jw
      ];

      file.dot-jj = {
        target = ".config/jj";
        source = "${dotfiles.jj}/.config/jj";
        recursive = true;
      };
    };
  };

}
