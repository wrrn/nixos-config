{
  device-conf,
  lib,
  pkgs,
  ...
}:
let
  inherit (device-conf) username displayName;
  inherit (pkgs.stdenv.hostPlatform.uname) system;
  home =
    {
      Linux = "/home/${username}";
      Darwin = "/Users/${username}";
    }
    .${system};
  module = lib.systemModule {
    linux = ./linux.nix;
  };
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    description = displayName;
    home = "${home}";
  };

  imports = [ module ];
}
