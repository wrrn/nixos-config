{
  lib,
  options,
  pkgs
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkIf optionalAttrs;
in
{
  config = mkIf isLinux (
    optionalAttrs (options ? virtualisation) ({
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
      };
    })
  );
}
