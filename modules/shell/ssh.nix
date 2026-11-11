{
  device-conf,
  ...
}:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username}.wrrn.dotfiles.ssh.enable = true;
}
