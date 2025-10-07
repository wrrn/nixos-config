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
    package = pkgs.lixPackageSets.stable.lix;

    # Enable the Flakes feature and accompanying new nix cli.
    settings = {
      trusted-users = [ "@admin" ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

}
