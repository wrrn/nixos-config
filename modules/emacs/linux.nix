{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;
  emacs = pkgs.unstable.emacs31-pgtk;
in
{
  home-manager.users.${username} = {
    services.emacs.package = emacs;

    programs.emacs = {
      package = emacs;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "emacsclient.desktop";
      };
    };

  };

}
