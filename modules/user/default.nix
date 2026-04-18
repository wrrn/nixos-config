{
  device-conf,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username displayName;
  inherit (pkgs.stdenv.hostPlatform.uname) system;
  module = lib.systemModule {
    linux = ./linux.nix;
    darwin = ./darwin.nix;
  };
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    description = displayName;
  };

  imports = [ module ];
}
