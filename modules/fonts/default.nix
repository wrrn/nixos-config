{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) fonts;
  inherit (device-conf) username;
  fontsToInstall = [
    pkgs.monalisa
    pkgs.triplicate
    pkgs.ellograph_cf
    pkgs.ellograph_cf_nerdfont
    pkgs.berkely_mono
    pkgs.ibm-plex
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.zed-mono
    pkgs.nerd-fonts.symbols-only
    pkgs.openmoji-color
    pkgs.openmoji-black
  ];
in
{
  nixpkgs.overlays = [ inputs.fonts.overlay ];

  environment.systemPackages = fontsToInstall;

  home-manager.users.${username}.home.packages = fontsToInstall;
  fonts.packages = fontsToInstall;

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "Triplicate A Code"
      "Symbols Nerd Font"
    ];
    sansSerif = [ "Ellograph CF" ];
    serif = [ "Triplicate A" ];
    emoji = [ "Openmoji Color" ];
  };
}
