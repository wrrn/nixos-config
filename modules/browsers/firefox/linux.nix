{
  username,
  pkgs,
}:
let
  profilesPath = ".mozilla/firefox";
in
{
  inherit profilesPath;
  module = {
    home-manager.users.${username}.programs.firefox.package = pkgs.firefox-bin;
  };
}
