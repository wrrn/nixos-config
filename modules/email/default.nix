{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      aerc
      notmuch
      w3m # Used for viewing html emails
      oama # Used for OAuth2 authentication
      gnupg # Used by oama for storing OAuth tokens
      pinentry-curses # Needed to generate gpg keys
    ];
  };
}
