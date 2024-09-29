{ fonts, ... }:
{
  environment.systemPackages = with fonts; [
    ellograph_cf
    ellograph_cf_nerdfont
  ];
}
