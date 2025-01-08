{
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) ghostty;
in
{
  environment.systemPackages = [
    ghostty.packages.${pkgs.system}.default
  ];
}
