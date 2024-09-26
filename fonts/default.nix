{ fonts, ... }:
{
  fonts.packages = with fonts; [
    ellograph_cf
    ellograph_cf_nerdfont
  ];
}
