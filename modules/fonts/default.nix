{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) fonts;
  inherit (config.device-conf) username;
  fontsToInstall = with pkgs; [
    ellograph_cf
    ellograph_cf_nerdfont
  ];
in
{
  nixpkgs.overlays = [ inputs.fonts.overlay ];

  environment.systemPackages = fontsToInstall;

  home-manager.users.${username}.home.packages = fontsToInstall;
  fonts.packages = fontsToInstall;
}
