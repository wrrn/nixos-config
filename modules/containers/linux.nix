{
  device-conf,
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkIf optionalAttrs;
  inherit (device-conf) username;
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

      users.users.${username}.extraGroups = [ "docker" ];
    })
  );
}
