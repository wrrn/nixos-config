{
  lib,
  options,
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkIf optionalAttrs;
  inherit (config.device-conf) username;
in
{
  config = mkIf isDarwin ({
    home-manager.users.${username}.home.packages = [
      pkgs.colima
      # pkgs.docker
    ];
  });
}
