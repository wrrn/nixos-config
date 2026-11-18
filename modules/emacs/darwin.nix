{
  device-conf,
  inputs,
  lib,
  ...
}:
let
  inherit (device-conf) username;
  wrrnpkgs = inputs.wrrnpkgs.packages.${device-conf.platform.system};
  package = wrrnpkgs.emacs-plus;
in
{

  services.emacs = {
    enable = true;
    inherit package;
  };
  home-manager.users.${username} =
    { config, pkgs, ... }:
    let
      cfg = config.programs.emacs;

      # What home-manager's programs.emacs would install (finalPackage),
      # minus extraConfig, which nothing here uses. Built by hand because
      # programs.emacs is disabled below.
      emacsFinal = ((pkgs.emacsPackagesFor package).overrideScope cfg.overrides).emacsWithPackages cfg.extraPackages;

      # The same Emacs, minus Applications/Emacs.app, so the launcher below can
      # own the "Emacs.app" name in ~/Applications/Home Manager Apps without a
      # buildEnv collision. The CLI (emacs, emacsclient, ...) is unchanged.
      emacsWithoutApp = pkgs.runCommand "${emacsFinal.name}-without-app" { } ''
        mkdir -p $out
        for f in ${emacsFinal}/*; do
          [ "$(basename "$f")" = Applications ] || ln -s "$f" $out/
        done
      '';

      # "Emacs.app" that starts a new Emacs instance on every launch. It opens
      # the real (wrapped) Emacs.app straight from the Nix store.
      emacsLauncher = wrrnpkgs.emacs-plus-launcher.override { emacsPkg = emacsFinal; };
    in
    {
      services.emacs = {
        inherit package;
        enable = true;
      };

      # programs.emacs always puts its Applications/Emacs.app into
      # home.packages, which would collide with the launcher. Its job is done
      # by emacsFinal/emacsWithoutApp above instead. Options such as
      # programs.emacs.extraPackages and .overrides are still honoured.
      programs.emacs = {
        enable = lib.mkForce false;
        inherit package;
      };

      home.packages = [
        emacsWithoutApp
        emacsLauncher
        wrrnpkgs.emacs-plus-client
      ];
    };
}
