{ config, ... }:
let
  inherit (config.device-conf) username;
in
{
  system.primaryUser = username;

}
