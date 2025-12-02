{
  device-conf,
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkIf optionalAttrs;
  inherit (device-conf) username;
in
{
  config = mkIf isDarwin ({
    home-manager.users.${username}.home.packages = [
      pkgs.colima
    ];

    homebrew = {
      enable = true;
      brews = [
        "docker"
        "docker-compose"
        "docker-buildx"
      ];
    };

  });
}
