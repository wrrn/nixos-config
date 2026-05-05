{
  config,
  device-conf,
  inputs,
  lib,
  ...
}:
let
  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = ./darwin.nix;
  };

  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
  dotfiles = inputs.dotfiles.packages.${system};

in
{
  imports = [ module ];
  home-manager.users.${username}.home.file = {
    ghostty-warm-burnout = {
      source = "${wrrnpkgs.warm-burnout}/share/warm-burnout/ghostty";
      target = ".config/ghostty/themes/";
      recursive = true;
    };

    ghostty = {
      source = "${dotfiles.ghostty}/dot-config/ghostty";
      target = ".config/ghostty/";
      recursive = true;
    };
  };
}
