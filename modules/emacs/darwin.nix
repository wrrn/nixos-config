{ device-conf, inputs, ... }:
let
  inherit (device-conf) username;
  wrrnpkgs = inputs.wrrnpkgs.packages.${device-conf.platform.system};
  package = wrrnpkgs.emacs-plus;
in
{

  services.emacs = {
    enable = true;
    inherit package;
  };
  home-manager.users.${username} = {
    services.emacs = {
      inherit package;
      enable = true;
    };
    programs.emacs = {
      inherit package;
    };

    home.packages = [ wrrnpkgs.emacs-plus-client ];
  };
}
