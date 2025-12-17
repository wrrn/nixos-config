{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      cliphist
      wl-clipboard
      xdg-utils
    ];

    services.cliphist.enable = true;
  };

}
