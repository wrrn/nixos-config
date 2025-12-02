{ device-conf, ... }:
let
  inherit (device-conf) username;
in
{
  system.primaryUser = username;

}
