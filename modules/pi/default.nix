# pi (https://pi.dev) integration module.
#
# Picks the correct platform-specific module based on the host's kernel.
# Currently only Linux is implemented; the darwin file is a stub.
{
  config,
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
  dotfiles = inputs.dotfiles.packages.${system};
  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = ./darwin.nix;
  };
in
{
  imports = [ module ];
  home-manager.users.${username} =
    { config, ... }:
    {
      # pi content (agent definitions, Two's protocol skills, prompt templates,
      # the global AGENTS.md) comes from the pi-agents flake. `checkout` links
      # ~/.pi/agent/{agents,skills,prompts,AGENTS.md} to the working clone, so
      # edits take effect without a rebuild; the clone is made by hand.
      # Drop `checkout` to use the flake's read-only store copy instead.
      imports = [ inputs.pi-agents.homeManagerModules.default ];
      programs.pi-agents = {
        enable = true;
        checkout = "${config.home.homeDirectory}/burrow/pi-agents";
      };

      home.packages = [
        wrrnpkgs.pi
        # nodejs is required for `pi install` (npm) and other Node-based LLM tooling.
        # Bumped from nodejs_20 → nodejs_22 to satisfy @gotgenes/pi-subagents'
        # `engines: ">=22"` (uses Promise.withResolvers / undici@8 webidl APIs).
        pkgs.nodejs_22
      ];

      home.file.dot-pi = {
        source = "${dotfiles.pi}/dot-config/pi";
        target = ".config/pi/";
        recursive = true;
      };
    };

  age.secrets.pi-search-keys = {
    file = ./pi-search-keys.age;
    owner = username;
    mode = "0400";
  };

  # System-wide shell init covers bash and zsh (and any POSIX shell that
  # sources /etc/profile). `set -a` auto-exports every assignment in the
  # sourced file. Fish is handled by the conf.d snippet referenced above,
  # driven off the PI_SEARCH_KEYS env var set just above.
  environment.shellInit = ''
    if [ -r ${config.age.secrets.pi-search-keys.path} ]; then
      set -a
      . ${config.age.secrets.pi-search-keys.path}
      set +a
    fi
  '';

  

}
