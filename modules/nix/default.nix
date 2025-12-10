{ device-conf, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (device-conf) username;
in
{
  imports = [
    ./darwin.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = device-conf.platform.system;

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
    };
  };

}
