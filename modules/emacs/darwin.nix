{ device-conf, inputs, ... }:
let
  inherit (device-conf) username;
  wrrnpkgs = inputs.wrrnpkgs.packages.${device-conf.platform.system};
in
{

  home-manager.users.${username} = {
    services.emacs.package = wrrnpkgs.emacs-plus;

    programs.emacs = {
      package = wrrnpkgs.emacs-plus;
    };

    home.packages = [ wrrnpkgs.emacs-plus-client ];
  };
}
