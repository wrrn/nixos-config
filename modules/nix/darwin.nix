{
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkIf optionalAttrs;
in
mkIf isDarwin (
  optionalAttrs (options ? services.nix-daemon) {
    services.nix-daemon.enable = true;
  }
)
