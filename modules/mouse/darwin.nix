{ inputs, ... }:
{
  imports = [ inputs.neru.darwinModules.default ];

  # Provides pkgs.neru, the signed release build the module installs by default.
  nixpkgs.overlays = [ inputs.neru.overlays.default ];

  # Runs Neru as a launchd user agent with the upstream default config.
  # Accessibility and Screen Recording are granted by hand on first launch;
  # `neru doctor` lists what is missing.
  services.neru.enable = true;
}
