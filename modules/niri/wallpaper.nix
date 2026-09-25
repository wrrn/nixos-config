{ device-conf, ... }:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username} = {
    services.awww.enable = true;
  };
}
