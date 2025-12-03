{ inputs, pkgs, ... }:
let
  master = import inputs.nixpkgs-staging {
    system = pkgs.stdenv.hostPlatform.system;
  };
  overlay = (
    final: prev: {
      ollama = master.ollama;
    }
  );
in
{
  nixpkgs.overlays = [ overlay ];
}
