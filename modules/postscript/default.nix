{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
in
{
  environment.systemPackages = with pkgs; [
    openssl
    readline
    sqlite
    xz
    zlib
    lzlib
    tcl
    tk
    pipenv
    buf
    openapi-generator-cli
    kcat
    redocly
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      awscli2
      amazon-ecr-credential-helper
      air # a live reloader for go binaries.
      gh
      copilot-language-server
      terraform
      go-mockery
      mongosh
      wrrnpkgs.mongodb-atlas-cli
      mongodb-compass
      act
    ];
  };

  homebrew = {
    enable = true;
    taps = [
      "atlassian/homebrew-acli"
    ];

    # Installing these via brew so that they are in the expected locations.
    brews = [
      # "acli"
      # "awscli"
      "openssl"
      "postgresql@14"
      "readline"
      "sqlite3"
      "tcl-tk"
      "xz"
      "zlib"
    ];

    casks = [
      "aws-vpn-client"
      "kreya"
    ];
  };
}
