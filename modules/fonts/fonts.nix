{ inputs, ... }:
let
  inherit (inputs) fonts;
in
{
  home.packages = with fonts; [
    ellograph_cf
    ellograph_cf_nerdfont
  ];
}
