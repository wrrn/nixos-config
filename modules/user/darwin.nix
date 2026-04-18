{ device-conf, ... }:
let
  inherit (device-conf) username displayName;
in
{
  users.users.${username}.home = "/Users/${username}";
}
