{
  inputs,
  ...
}:
let
  inherit (inputs) ghostty;
in
{
  environment.systemPackages = [
    ghostty.packages.x86_64-linux.default
  ];
}
