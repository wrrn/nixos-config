{
  device-conf,
  lib,
  options,
  ...
}:
let
  inherit (device-conf) username;
in
{
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
}
