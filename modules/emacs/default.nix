{
  device-conf,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  dotfiles = inputs.dotfiles.packages.${device-conf.platform.system};

  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = ./darwin.nix;
  };
in
{

  imports = [ module ];
  environment.variables.EDITOR = "emacsclient";

  environment.systemPackages = with pkgs; [
    ispell
    python3
    emacs.pkgs.vterm
    glibtool
    cmake
    taplo
    gopls
    pyright
    typescript-language-server
  ];

  home-manager.users.${username} = {
    services.emacs = {
      enable = true;
      client.enable = true;
      defaultEditor = true;
      startWithUserSession = "graphical";
    };

    programs.emacs = {
      enable = true;      
    };
    
    home = {
      packages = [
        pkgs.global
      ];

      file.dot-emacs = {
        source = "${dotfiles.emacs}/.config/emacs";
        target = ".config/emacs";
        recursive = true;
      };
    };
  };
}
