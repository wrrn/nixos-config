{
  lib,
  pkgs,
  options,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkIf optionalAttrs;
  inherit (config.device-conf) hostname;
in
mkIf isDarwin (
  optionalAttrs (options ? networking.computerName) ({
    networking.computerName = hostname;
  })
  // optionalAttrs (options ? networking.localHostName) ({
    networking.localHostName = hostname;
  })
)
