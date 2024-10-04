{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
  inherit (config.device-conf) username;
in
{
  config = mkIf isDarwin ({
    home-manager.users.${username}.home.packages = [
      pkgs.colima
    ];
  });
}

# {
#   lib,
#   config,
#   pkgs,
#   ...
# }:
# let
#   inherit (lib) mkIf isDarwin;
#   inherit (config.device-confg) username;
# in
# {
#   config = mkIf isDarwin ({
#     home-manager.users.${username} = {
#       home.packages = [
#         pkgs.colima
#       ];
#     };
#   });
# }
