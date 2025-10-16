{ inputs, pkgs, ...}:
let
  master = import inputs.nixpkgs-master {
          system = pkgs.stdenv.hostPlatform.system;
        };
overlay = (final: prev: { 
rubyPackages = prev.rubyPackages // {  nokogiri = master.rubyPackages.nokogiri; };
jsonnet = master.jsonnet;
});
in
{
nixpkgs.overlays = [ overlay ];
}
