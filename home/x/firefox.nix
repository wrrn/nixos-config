{
  pkgs,
  config,
  userChrome,
  ...
}:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    profiles = {
      dev-edition-default = {
        id = 1;
        containersForce = true;
        isDefault = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        containers = {
          personal = {
            id = 1;
            color = "green";
            icon = "circle";
            name = "personal";
          };
          banking = {
            id = 2;
            color = "purple";
            icon = "circle";
            name = "banking";
          };
        };
        userChrome = userChrome;
      };
    };
  };
}
