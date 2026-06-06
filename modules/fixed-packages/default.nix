{ inputs, pkgs, ... }:
let

  # nixpkgs ollama 0.21.1 has a Darwin postPatch that `rm`s a file no longer
  # in upstream (model/models/nemotronh/model_omni_test.go), failing patchPhase.
  # Replace the bare `rm` with `rm -f` so missing files are tolerated.
  ollamaPatchFix = pkgs.master.ollama.overrideAttrs (old: {
    postPatch =
      builtins.replaceStrings
        [ "rm model/models/nemotronh/model_omni_test.go" ]
        [ "rm -f model/models/nemotronh/model_omni_test.go" ]
        old.postPatch;
  });

  # dnsmasq: NixOS stdenv's _FORTIFY_SOURCE hardening trips over dnsmasq's
  # union-based cache name storage when /etc/hosts contains hostnames longer
  # than ~47 bytes, causing a SIGABRT in read_hostsfile.
  # See: https://github.com/NixOS/nixpkgs/issues/... (TODO: file upstream)
  dnsmasqFortifyFix = pkgs.master.dnsmasq.overrideAttrs (old: {
    hardeningDisable = (old.hardeningDisable or [ ]) ++ [ "fortify" ];
  });

  overrides = {
    # _1password = pkgs.master._1password-cli;
    # _1password-cli = pkgs.master._1password-cli;
    # _1password-gui = pkgs.master._1password-gui;
    dnsmasq = dnsmasqFortifyFix;
    ollama = ollamaPatchFix;
  };

  overlay = final: prev: overrides;
  fixedPackageNames = pkgs.lib.concatStringsSep ", " (pkgs.lib.attrNames overrides);

in
{
  nixpkgs.overlays = [
    overlay

    # dnsmasqFortifyFix
    # ldacbtEndianFix
  ];
  warnings = [
    # "The following packages are being fixed: ${fixedPackageNames}"
  ];
}
