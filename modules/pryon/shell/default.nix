{ config, pkgs, ... }:
let
  inherit (config.device-conf) username;
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      envsubst
      kubernetes-helm
    ];
  };
}
