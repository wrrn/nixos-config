{ inputs, pkgs, ... }:
let
  master = import inputs.nixpkgs-staging {
    system = pkgs.stdenv.hostPlatform.system;
  };

  overlay = (
    final: prev: {
      ollama = master.ollama;

      direnv = prev.direnv.overrideAttrs (old: {
        doCheck = false;
      });
    }
  );
in
{
  nixpkgs.overlays = [ overlay ];
  warnings = [ "The following packages are being fixed: ollama, direnv" ];
}
