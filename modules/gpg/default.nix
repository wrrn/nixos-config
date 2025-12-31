{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;
in
{
  users.users.${username}.packages = [ pkgs.gnupg ];
  programs.gnupg.agent.enable = true;
}
