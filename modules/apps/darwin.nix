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
    home.packages = with pkgs; [
      mas
      skhd
      shortcat
      itsycal
      bartender
      emacs-plus
      little-snitch
      amethyst
      dash-docs
      alfred-mac
      inyourface
      monodraw
      hammerspoon
    ];
  };

  homebrew = {
    enable = true;
    # taps = [
    # {
    # name = "pryoninc";
    # clone_target = "ssh://git@bitbucket.org/pryoninc/homebrew-tap";
    # force_auto_update = true;
    # }
    # ];

    # brews = [
    # "pryoninc/k8s_wait_for"
    # ];

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
