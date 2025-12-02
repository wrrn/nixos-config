{ device-conf, ... }:
{
  system.stateVersion = device-conf.nixOS.stateVersion;
}
