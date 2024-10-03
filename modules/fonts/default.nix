{ config, inputs, ... }:
let
  inherit (inputs) fonts;
  inherit (config.device-conf) username;
in
{
  environment.systemPackages = with fonts; [
    ellograph_cf
    ellograph_cf_nerdfont
  ];

  home-manager.users.${username}.home.packages = with fonts; [
    ellograph_cf
    ellograph_cf_nerdfont
  ];
}
