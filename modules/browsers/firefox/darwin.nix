{ device-conf, ... }:
let
  inherit (device-conf) username;
in
{
  # Install Firefox via Homebrew so that 1Password can fill passwords in it.
  homebrew = {
    enable = true;
    casks = [ "firefox@developer-edition" ];
  };

  home-manager.users.${username}.programs.firefox.package = null;
}
