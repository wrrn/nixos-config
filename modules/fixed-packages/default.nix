{ inputs, pkgs, ... }:
let
  overrides = {
    _1password = pkgs.master._1password-cli;
    _1password-cli = pkgs.master._1password-cli;
    _1password-gui = pkgs.master._1password-gui;
  };

  fixedPackageNames = pkgs.lib.concatStringsSep ", " (pkgs.lib.attrNames overrides);

  overlay = final: prev: overrides;

  # nixpkgs ollama 0.21.1 has a Darwin postPatch that `rm`s a file no longer
  # in upstream (model/models/nemotronh/model_omni_test.go), failing patchPhase.
  # Replace the bare `rm` with `rm -f` so missing files are tolerated.
  ollamaPatchFix = final: prev: {
    ollama = prev.ollama.overrideAttrs (old: {
      postPatch =
        builtins.replaceStrings
          [ "rm model/models/nemotronh/model_omni_test.go" ]
          [ "rm -f model/models/nemotronh/model_omni_test.go" ]
          old.postPatch;
    });
  };
in
{
  nixpkgs.overlays = [
    # overlay
    # ollamaPatchFix
  ];
  warnings = [
    # "The following packages are being fixed: ${fixedPackageNames}, ollama (patchPhase rm -f)"
  ];
}
