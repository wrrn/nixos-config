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
  packages =
    input:
    import input {
      inherit system;
      config.allowUnfree = true;
    };
  unstable = packages inputs.nixpkgs-unstable;
  staging = packages inputs.nixpkgs-staging;
  master = packages inputs.nixpkgs-master;
in
{
  imports = [
    (lib.systemModule {
      darwin = ./darwin.nix;
      linux = { };
    })
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = system;
  nixpkgs.overlays = [
    (final: prev: { inherit unstable staging master; })
  ];

  nix = {
    package = pkgs.lixPackageSets.stable.lix;

    settings = {
      trusted-users = [
        "@admin"
        username
      ];

      # Enable the Flakes feature and accompanying new nix cli.
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      max-jobs = "auto";
      cores = 0;

    };
  };

}
