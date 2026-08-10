{ ... }:
{
  # Intel Wi-Fi 7 BE201 (iwlwifi / iwlmld) stability workarounds.
  #
  # Symptoms this addresses:
  #   * At boot the card sends auth frames and never hears the AP reply
  #     ("send auth try 1/3..3/3" -> "aborting authentication by local
  #     choice, Reason: 3=DEAUTH_LEAVING"), so it only connects after a
  #     manual `systemctl restart wpa_supplicant`.
  #   * "missed beacons exceeds threshold" drops mid-session.
  #
  # Fixes, in order of impact:
  #   1. Disable Wi-Fi power saving (stops beacon-loss drops).
  #   2. Disable Bluetooth coexistence (a common cause of BE200/BE201
  #      pre-association auth timeouts).
  # If it is still flaky after this, add `disable_11be=1` to the options
  # line below to fall back off the new/buggy Wi-Fi 7 MLD path.
  networking.networkmanager.wifi.powersave = false;

  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0 bt_coex_active=0
  '';
}
