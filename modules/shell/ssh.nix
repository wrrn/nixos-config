{
  config,
  pkgs,
  ...
}:
let
  inherit (config.device-conf) username;
in
{
  home-manager.users.${username}.home.file.ssh = {
    source = "${pkgs.dotfiles.ssh}/.ssh/config";
    target = ".ssh/config";
  };
}
