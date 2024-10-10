{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.device-conf) username displayName;
  inherit (pkgs.stdenv) isLinux isDarwin;
  home =
    {
      Linux = "/home/${username}";
      Darwin = "/Users/${username}";
    }
    .${pkgs.hostPlatform.uname.system};
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} =
    {
      description = displayName;
      home = "${home}";
    }
    // lib.optionalAttrs (pkgs.stdenv.isLinux) {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
}
