{
  device-conf,
  inputs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${system};
in
{
  home-manager.users.${username}.home.file.ssh = {
    source = "${dotfiles.ssh}/.ssh/config";
    target = ".ssh/config";
  };
}
