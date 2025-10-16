{ config, pkgs, ... }:
let
  inherit (config.device-conf) username;
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      aerc
      notmuch
      w3m # Used for viewing html emails
    ];
  };
}
