let
  batteryPath = "/sys/class/power_supply/BAT0";
in
{
  services.power-profiles-daemon.enable = true;

  services.logind.settings.Login = {
    HandlePowerKey = "poweroff";
    HandleLidSwitch = "suspend";
    # HandleLidSwitchExternalPower = "ignore";
  };

  systemd.services.battery-charge-limit = {
    description = "Configure battery charge thresholds";
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathExists = "${batteryPath}/charge_types";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      echo 50 > ${batteryPath}/charge_control_start_threshold
      echo 80 > ${batteryPath}/charge_control_end_threshold
      echo Custom > ${batteryPath}/charge_types
    '';
  };
}
