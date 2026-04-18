_:{

    home-manager.users.${username} = {
      services.emacs.package = pkgs.emacs30-pgtk;

    programs.emacs = {
      package = pkgs.emacs30-pgtk;
    };

    };

   xdg.mimeApps = {
     enable = true;
     defaultApplications = {
       "text/plain" = "emacsclient.desktop";
     };
   };
}
