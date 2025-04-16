{ config, pkgs, ... }:
let
  inherit (config.device-conf) username;
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      aider-chat
      python312Packages.google-generativeai
    ];
  };
}
