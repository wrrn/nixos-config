{ lib, pkgs, ... }:
let
  internalKeyboardSysfs = "/sys/bus/serio/devices/serio0/input";
  keychronBluezPath = "/org/bluez/hci0/dev_6C_93_08_62_5C_9A";
  sweepUsbVendorId = "8d1d";
  sweepUsbProductId = "ec17";

  externalKeyboardMonitor = pkgs.writeShellApplication {
    name = "external-keyboard-monitor";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.systemd
    ];
    text = builtins.readFile ./external-keyboard.sh;
  };
in
{
  systemd.services.external-keyboard-inhibits-laptop-keyboard = {
    description = "Inhibit the laptop keyboard while an external keyboard is connected";
    after = [ "bluetooth.service" ];
    wants = [ "bluetooth.service" ];
    wantedBy = [ "multi-user.target" ];

    unitConfig.ConditionPathExists = "/sys/bus/serio/devices/serio0";

    serviceConfig = {
      Type = "simple";
      ExecStart = lib.escapeShellArgs [
        "${externalKeyboardMonitor}/bin/external-keyboard-monitor"
        "--internal-keyboard-sysfs"
        internalKeyboardSysfs
        "--keychron-bluez-path"
        keychronBluezPath
        "--sweep-usb-vendor-id"
        sweepUsbVendorId
        "--sweep-usb-product-id"
        sweepUsbProductId
      ];
      Restart = "always";
      RestartSec = "1s";
    };
  };
}
