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
    home.packages = [
      pkgs.wezterm
    ];

    # Links ~/.wezterm.lua, which wezterm reads when
    # ~/.config/wezterm/wezterm.lua doesn't exist.
    wrrn.dotfiles.wezterm.enable = true;
  };
}
