{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{

  home-manager.users.${username} = {
    programs.aerospace = {
      enable = true;
      package = pkgs.unstable.aerospace;
      launchd.enable = true;
    };

    wrrn.dotfiles.aerospace.enable = true;
  };

}
