# Darwin-specific pi configuration.
#
# Placeholder — agenix integration for pi-search keys on nix-darwin is not
# yet implemented. The Linux module at ./linux.nix can be ported once needed:
# swap `inputs.agenix.nixosModules.default` for
# `inputs.agenix.darwinModules.default` and verify the decrypted path
# (typically /run/agenix/pi-search-keys on darwin, same as Linux, but
# confirm with `nix eval .#darwinConfigurations.<host>.config.age.secretsDir`).
{ config, inputs, ... }:
{
  imports = [ inputs.agenix.darwinModules.default ];

  # Expose the decrypted file's path so shells outside bash/zsh (notably
  # fish, which does not source /etc/profile) can locate it. The matching
  # fish snippet lives at
  # dotfiles/fish/.config/fish/conf.d/05-pi-search.fish and reads each
  # KEY=value line from $PI_SEARCH_KEYS into the environment.
  environment.variables.PI_SEARCH_KEYS = config.age.secrets.pi-search-keys.path;
}
