{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.gcc
  ];
}
