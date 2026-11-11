{
  device-conf,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;

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

    wrrn.dotfiles.emacs.enable = true;

    programs.emacs = {
      enable = true;      
    };

    systemd.user.services.emacs = {
      Unit = {
        After = [ "wayland-ready.service" ];
        Wants = [ "wayland-ready.service" ];
      };
    };
    
    home = {
      packages = [
        pkgs.global
      ];
    };
  };
}
