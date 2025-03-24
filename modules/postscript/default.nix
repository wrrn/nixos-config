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
      awscli2
      amazon-ecr-credential-helper
      air # a live reloader for go binaries.
      gh
      copilot-language-server
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
    ];

    casks = [
      "docker"
    ];
  };
}
