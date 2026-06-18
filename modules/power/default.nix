_: {
  services.power-profiles-daemon.enable = true;

  services.logind.settings.Login = {
    HandlePowerKey = "poweroff";
    HandleLidSwitch = "suspend";
    # HandleLidSwitchExternalPower = "ignore";
  };
}
