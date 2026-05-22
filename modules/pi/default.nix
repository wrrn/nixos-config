# pi (https://pi.dev) integration module.
#
# Picks the correct platform-specific module based on the host's kernel.
# Currently only Linux is implemented; the darwin file is a stub.
{
  device-conf,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = ./darwin.nix;
  };
in
{
  imports = [ module ];
  home-manager.users.${username}.home.packages = [
    wrrnpkgs.pi
    # nodejs is required for `pi install` (npm) and other Node-based LLM tooling
    pkgs.nodejs_20
  ];

}
