{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{
  nixpkgs.overlays = [ inputs.wrrnpkgs.overlays.default ];
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      google-chrome
      ice-bar
      mas
      net-news-wire
      ollama
      skhd
      wrrn.amethyst
      wrrn.hammerspoon
      wrrn.monodraw
      wrrn.shortcat
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };

    taps = [
      "brettferdosi/tap"
      "jonas-grgt/ktea"
    ];

    brews = [
      "ktea" # Kafka message viewer TODO migrate this to a nix package
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "Apple Configurator" = 1037126344;
      "Be Focused Pro" = 961632517;
      "Capo" = 696977615;
      "Create Booklet 2" = 1350225911;
      "Gestimer" = 6447125648;
      "Grila" = 6444335028;
      "HazeOver" = 430798174;
      "In Your Face" = 1476964367;
      "Instapaper" = 288545208;
      "Maccy" = 1527619437;
      "Stretch It" = 6670762193;
      "rcmd" = 1596283165;
    };

    casks = [
      "brettferdosi/tap/grayscale"
      "cold-turkey-blocker"
      "dayflow"
      "handy"
      "itsycal" # It needs to be installed in the /Applications directory
      "little-snitch" # It needs to be installed to the /Applications directory.
      "lunar"
      "meetingbar"
      "reader"
      "alfred" # Install via brew because the trampoline is not working
      "flux-app"
      "sol"
      "halloy"
      "leader-key"
    ];
  };
}
