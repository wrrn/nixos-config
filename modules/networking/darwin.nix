{
  device-conf,
  lib,
  options,
  ...
}:
let
  inherit (lib) optionalAttrs;
  inherit (device-conf) hostname;
in
optionalAttrs (options ? networking.computerName) ({
  networking.computerName = hostname;
})
// optionalAttrs (options ? networking.localHostName) ({
  networking.localHostName = hostname;
})
