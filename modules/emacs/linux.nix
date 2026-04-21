{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username} = {
    services.emacs.package = pkgs.emacs30-pgtk;

    programs.emacs = {
      package = pkgs.emacs30-pgtk;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "emacsclient.desktop";
      };
    };

  };

}
