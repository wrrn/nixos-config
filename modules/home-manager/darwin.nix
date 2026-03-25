{
  device-conf,
  ...
}:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username}.targets.darwin = {
    copyApps.enable = true;
    linkApps.enable = false;
  };
}
