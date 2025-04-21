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
  nixpkgs.overlays = [ inputs.wrrnpkgs.overlays.macApps ];
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      amethyst
      google-chrome
      hammerspoon
      ice-bar
      itsycal
      mas
      monodraw
      net-news-wire
      ollama
      shortcat
      skhd
      zen-browser
    ];
  };

  homebrew = {
    enable = true;
    masApps = {
      "Amphetamine" = 937984704;
      "Be Focused Pro" = 961632517;
      "Create Booklet 2" = 1350225911;
      "Gestimer" = 990588172;
      "HazeOver" = 430798174;
      "In Your Face" = 1476964367;
      "rcmd" = 1596283165;
    };

    casks = [
      "alfred" # Install via brew because the trampoline is not working
      "cold-turkey-blocker"
      "little-snitch" # It needs to be installed to the /Applications directory.
      "lunar"
    ];
  };
}
