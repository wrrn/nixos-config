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
      mas
      skhd
      shortcat
      itsycal
      amethyst
      monodraw
      hammerspoon
      ollama
      ice-bar
      google-chrome
      zen-browser
    ];
  };

  homebrew = {
    enable = true;
    masApps = {
      "Amphetamine" = 937984704;
      "Create Booklet 2" = 1350225911;
      "Gestimer" = 990588172;
      "HazeOver" = 430798174;
      "rcmd" = 1596283165;
      "Be Focused Pro" = 961632517;
      "In Your Face" = 1476964367;
    };

    casks = [
      "alfred" # Install via brew because the trampoline is not working
      "cold-turkey-blocker"
      "little-snitch" # It needs to be installed to the /Applications directory.
    ];
  };
}
