{
  device-conf,
  lib,
  pkgs,
  options,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkIf optionalAttrs;
  inherit (device-conf) hostname;
in
mkIf isDarwin (
  optionalAttrs (options ? networking.computerName) ({
    networking.computerName = hostname;
  })
  // optionalAttrs (options ? networking.localHostName) ({
    networking.localHostName = hostname;
  })
)
