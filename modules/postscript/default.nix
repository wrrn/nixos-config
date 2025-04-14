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
  ];
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      amazon-ecr-credential-helper
      air # a live reloader for go binaries.
      gh
      copilot-language-server
      jira-cli-go
    ];
  };

  homebrew = {
    enable = true;

    # Installing these via brew so that they are in the expected locations.
    brews = [
      "openssl"
      "readline"
      "sqlite3"
      "xz"
      "zlib"
      "tcl-tk"
      "postgresql@14"
      "mockery"
      "awscli"
    ];

    casks = [
      "docker"
      "aws-vpn-client"
    ];
  };
}
