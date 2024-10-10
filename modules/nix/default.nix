{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  imports = [
    ./darwin.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;

    # Enable the Flakes feature and accompanying new nix cli.
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

}
