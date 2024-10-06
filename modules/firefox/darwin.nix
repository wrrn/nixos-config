{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (config.device-conf) username;
in
{

  nixpkgs.overlays = [ inputs.wrrnpkgs.overlay.macApps ];
  home-manager.users.${username} = {
    programs.firefox = {
      # For some reason home-manager won't install the correct firefox
      # version. We need to install it via home.packages.
      package = null;
    };

    home.packages = [
      pkgs.firefox-devedition-darwin
    ];
  };

}
