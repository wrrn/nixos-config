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
    programs.starship.enable = true;
    wrrn.dotfiles.starship.enable = true;
  };

}
