{
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkIf optionalAttrs;
in
{
  config = mkIf isLinux (
    optionalAttrs (options ? virtualisation) ({
      virtualisation.docker = {
        enable = true;
        daemon.settings = {
          iptables = true;
          features = {
            containerd-snapshotter = true;
          };
        };
      };
    })
  );
}
