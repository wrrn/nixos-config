### Generate the options that will be added to the firefox installation.
{
  username,
  ...
}:
let
  firefoxConfigPath = "Library/Application Support/Firefox";
  profilesPath = "${firefoxConfigPath}/Profiles";
in
{
  inherit profilesPath;
  ## Install firefox via homebrew so that we are able to get our passwords from
  ## 1password.
  module = {
    homebrew = {
      enable = true;
      casks = [
        "firefox@developer-edition"
      ];
    };
    home-manager.users.${username}.programs.firefox.package = null;
  };
}
