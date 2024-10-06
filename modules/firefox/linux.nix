{
  config,
  pkgs,
  ...
}:
{
  home-manager.users.${username} = {
    progams.firefox = {
      package = pkgs.firefox;
    };
  };
}
