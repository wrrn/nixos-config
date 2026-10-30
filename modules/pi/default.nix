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
  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = ./darwin.nix;
  };
in
{
  imports = [ module ];
  home-manager.users.${username} =
    { config, lib, ... }:
    let
      dotfilesCheckout = "${config.home.homeDirectory}/burrow/dotfiles";
      # Every regular file in dotfiles' pi/dot-pi/agent/, read from the locked
      # dotfiles input. A new config file there gets linked after
      # `nix flake update dotfiles`.
      piConfigDir = "${inputs.dotfiles}/pi/dot-pi/agent";
      piConfigFiles = builtins.attrNames (
        lib.filterAttrs (_: type: type == "regular") (builtins.readDir piConfigDir)
      );
    in
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

      # pi config (settings, models, keybindings, subagent settings) from the
      # dotfiles checkout. Out-of-store links, not store copies: pi writes to
      # settings.json (lastChangelogVersion, `pi install` packages), so the
      # files must stay writable. Replaces `make pi.stow` in dotfiles.
      home.file = lib.listToAttrs (
        map (name: {
          name = "pi-config-${name}";
          value = {
            source = config.lib.file.mkOutOfStoreSymlink "${dotfilesCheckout}/pi/dot-pi/agent/${name}";
            target = ".pi/agent/${name}";
            force = true;
          };
        }) piConfigFiles
      );

      home.activation.piConfigCheckout = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -d ${lib.escapeShellArg dotfilesCheckout} ]; then
          echo "pi config: ${dotfilesCheckout} is missing; the ~/.pi/agent/*.json links dangle until it's cloned" >&2
        fi
      '';
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
