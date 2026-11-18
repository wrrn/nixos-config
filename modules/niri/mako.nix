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

    # Battery/power notifications via upower; thresholds come from UPower.conf.
    services.poweralertd.enable = true;

    wrrn.dotfiles.mako.enable = true;
  };
}
