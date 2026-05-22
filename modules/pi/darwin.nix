# Darwin-specific pi configuration.
#
# Placeholder — agenix integration for pi-search keys on nix-darwin is not
# yet implemented. The Linux module at ./linux.nix can be ported once needed:
# swap `inputs.agenix.nixosModules.default` for
# `inputs.agenix.darwinModules.default` and verify the decrypted path
# (typically /run/agenix/pi-search-keys on darwin, same as Linux, but
# confirm with `nix eval .#darwinConfigurations.<host>.config.age.secretsDir`).
_: { }
