{
  device-conf,
  ...
}:
let
  inherit (device-conf) username;
in
## Install via homebrew so that we are able to get our passwords from
## 1password.
{
  homebrew = {
    enable = true;
    casks = [
      "zen"
    ];
  };
  home-manager.users.${username}.programs.zen-browser.package = null;
}
