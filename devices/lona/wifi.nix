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
  #
  # 2026-08-10 - WPA3-SAE regression on the "Coffee-5G" network:
  #   The AP firmware was upgraded (Thu 2026-08-07) which switched the SSID
  #   into WPA3 transition mode (RSN advertises both `psk` and `sae`) with
  #   PMF required. NetworkManager auto-upgraded the saved profile to
  #   key-mgmt=sae / pmf=required, and the iwlmld + wpa_supplicant 2.11 SAE
  #   path fails pre-association: the card sends the auth frame, the AP never
  #   replies, and it loops on CONN_FAILED ("association took too long").
  #   WPA2-only networks (e.g. "marshall") on the same hardware were fine.
  #
  #   Workaround (applied imperatively, NOT managed here) - pin the laptop to
  #   the WPA2-PSK side of the transition network to skip the buggy SAE path:
  #     nmcli connection modify Coffee-5G \
  #       802-11-wireless-security.key-mgmt wpa-psk \
  #       802-11-wireless-security.pmf 1        # 1 = disable PMF
  #   Revert to `sae` once a newer kernel/iwlwifi firmware fixes iwlmld SAE.
  networking.networkmanager.wifi.powersave = false;

  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0 bt_coex_active=0
  '';
}
