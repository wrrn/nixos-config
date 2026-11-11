{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      google-chrome
      ice-bar
      mas
      net-news-wire
      ollama
      skhd
      wrrnpkgs.amethyst
      wrrnpkgs.hammerspoon
      wrrnpkgs.monodraw
      wrrnpkgs.shortcat
    ];
  };

  homebrew = {
    enable = true;
    greedyCasks = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
      extraFlags = [ "--force-cleanup" ];
    };

    masApps = {
      "Amphetamine" = 937984704;
      "Apple Configurator" = 1037126344;
      "Capo" = 696977615;
      "Create Booklet 2" = 1350225911;
      "Gestimer" = 6447125648;
      "HazeOver" = 430798174;
      "Instapaper" = 288545208;
      "Maccy" = 1527619437;
      "iA Writer" = 775737590;
    };

    casks = [
      "cold-turkey-blocker"
      "dayflow"
      "little-snitch" # It needs to be installed to the /Applications directory.
      "lunar"
      "leader-key"
      "calibre"
      "rcmd"
    ];
  };
}
