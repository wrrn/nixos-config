# Linux-specific pi configuration.
#
# Provisions pi-search's API keys through agenix and sources them into the
# system shell init so every interactive shell sees TAVILY_API_KEY,
# EXA_API_KEY, and (optionally) JINA_API_KEY when starting pi.
#
# Before this module activates successfully:
#
#   1. Generate the encrypted secret file:
#
#        cd secrets
#        EDITOR=nvim agenix -e pi-search-keys.age
#
#      Paste content shaped like:
#
#        TAVILY_API_KEY=tvly-...
#        EXA_API_KEY=...
#        # JINA_API_KEY=jina_...        (optional)
#        # PI_SEARCH_LIMIT=50           (optional, overrides default 30)
#
#   2. Make sure `secrets/secrets.nix` lists every host that needs to
#      decrypt the file (see that file's comments).
#
#   3. Import this module from each device that should have pi-search keys
#      by adding `../../modules/pi` to the device's modules list.
{
  config,
  device-conf,
  inputs,
  ...
}:
let
  inherit (device-conf) username;
in
{
  imports = [ inputs.agenix.nixosModules.default ];

  age.secrets.pi-search-keys = {
    file = ./pi-search-keys.age;
    owner = username;
    mode = "0400";
  };

  # Expose the decrypted file's path so shells outside bash/zsh (notably
  # fish, which does not source /etc/profile) can locate it. The matching
  # fish snippet lives at
  # dotfiles/fish/.config/fish/conf.d/05-pi-search.fish and reads each
  # KEY=value line from $PI_SEARCH_KEYS into the environment.
  environment.sessionVariables.PI_SEARCH_KEYS =
    config.age.secrets.pi-search-keys.path;

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
