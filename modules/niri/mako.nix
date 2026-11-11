{
  pkgs,
  device-conf,
  ...
}:
let
  inherit (device-conf) username;
in
{

  home-manager.users.${username} = {
    services.mako.enable = true;

    wrrn.dotfiles.mako.enable = true;
  };
}
