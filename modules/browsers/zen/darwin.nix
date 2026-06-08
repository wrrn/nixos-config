{
  username,
  ...
}:
let
  zenConfigPath = "Library/Application Support/zen";
  profilesPath = "${zenConfigPath}/Profiles";
in
{
  inherit profilesPath;
  module = {
    ## Install via homebrew so that we are able to get our passwords from
    ## 1password.
    homebrew = {
      enable = true;
      casks = [
        "zen"
      ];
    };
    home-manager.users.${username}.programs.zen-browser.package = null;
  };
}
