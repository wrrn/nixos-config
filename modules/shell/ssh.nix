{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username}.home.file.ssh = {
    source = "${pkgs.dotfiles.ssh}/.ssh/config";
    target = ".ssh/config";
  };
}
