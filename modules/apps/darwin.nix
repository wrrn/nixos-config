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
      emacs-plus
      emacs-plus-client
      little-snitch
      amethyst
      alfred-mac
      monodraw
      hammerspoon
      ollama
      ice-bar
      google-chrome
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
    };
  };
}
