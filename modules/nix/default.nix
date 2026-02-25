{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./darwin.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = system;
  nixpkgs.overlays = [
    (final: prev: { inherit unstable; })
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
