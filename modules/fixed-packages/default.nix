{
  inputs,
  pkgs,
  lib,
  ...
}:
{ }
# let
#   staging = import inputs.nixpkgs-staging {
#     system = pkgs.stdenv.hostPlatform.system;
#   };
#   wrrnsbcl = inputs.wrrnpkgs.packages.${pkgs.stdenv.hostPlatform.system}.sbcl.overrideAttrs {
#     doCheck = false;
#   };
#   overlay = (
#     final: prev: {
#       rubyPackages = prev.rubyPackages // {
#         nokogiri = staging.rubyPackages.nokogiri;
#       };
#       jsonnet = staging.jsonnet;
#       sbcl = wrrnsbcl;
#       lispPackages = prev.lispPackages.override {
#         sbcl = final.sbcl;
#       };
#     }
#   );
# in
# {
#   nixpkgs.overlays = [
#     overlay
#     inputs.cl-nix-lite.overlays.default
#   ];
# }
