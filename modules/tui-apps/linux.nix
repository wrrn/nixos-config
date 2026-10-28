{
  device-conf,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  ghostty = lib.getExe pkgs.staging.ghostty;

  # Launch Ghostty directly rather than setting Terminal=true. With
  # Terminal=true the launcher picks the terminal, and fuzzel falls back to
  # foot when $TERMINAL is unset.
  #
  # cmd is looked up on PATH: wiremix and herdr come from `nix profile`.
  mkTuiEntry =
    id:
    {
      name,
      icon,
      cmd ? id,
      comment ? null,
    }:
    {
      inherit name icon comment;
      exec = "${ghostty} -e ${cmd}";
      terminal = false;
      categories = [ "Utility" ];
    };
in
{
  home-manager.users.${username}.xdg.desktopEntries = lib.mapAttrs mkTuiEntry {
    nmtui = {
      name = "Network (nmtui)";
      comment = "Configure NetworkManager connections";
      icon = pkgs.fetchurl {
        url = "https://networkmanager.dev/logo.png";
        hash = "sha256-JaxKSeGRIaHckmC8/CTdBlsrFZ2jBqq3c7RmcmTeETs=";
      };
    };

    wiremix = {
      name = "wiremix";
      comment = "PipeWire audio mixer";
      # The project avatar is 1200x891. Crop the centre to a square so
      # launchers don't letterbox it.
      icon =
        let
          avatar = pkgs.fetchurl {
            url = "https://gitlab.freedesktop.org/uploads/-/system/project/avatar/4753/pipewire.png";
            hash = "sha256-QE3x3kKhcxPAD1j2bN/hFRKulZ65DG44eKJsQDGFj6s=";
          };
        in
        pkgs.runCommand "pipewire-icon.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
          magick ${avatar} -gravity center -crop 891x891+0+0 +repage $out
        '';
    };

    herdr = {
      name = "herdr";
      comment = "Terminal multiplexer for coding agents";
      icon = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/herdrdev/herdr/v0.9.5/assets/logo.svg";
        hash = "sha256-9KhADVFfz1ARKpUqW0j1+m5rArTcsLSDypK+OffX96E=";
      };
    };
  };
}
