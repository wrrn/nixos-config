# Links dotfiles packages to the working clone at ~/burrow/dotfiles instead of
# the locked flake input, so edits take effect without a rebuild. Import it on
# hosts that have the clone; activation warns if it's missing.
#
# Modules choose packages with wrrn.dotfiles.<package>.enable (the module
# comes from modules/home-manager). Set wrrn.dotfiles.<package>.source =
# "store" to pin one package to flake.lock.
{ device-conf, ... }:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username} =
    { config, ... }:
    {
      wrrn.dotfiles.localPath = "${config.home.homeDirectory}/burrow/dotfiles";
    };
}
