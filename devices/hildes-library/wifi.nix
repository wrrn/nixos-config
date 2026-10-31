# Home wifi profile, with SSID and PSK from an agenix secret.
#
# The secret is encrypted to this host's SSH host key, which is generated
# ahead of install and copied to /mnt/etc/ssh/ before `nixos-install`.
#
# Create or edit it from the repo root (editing needs a recipient's key, e.g.
# bandit's host key):
#
#   agenix -e devices/hildes-library/wifi.age
#   sudo agenix -i /etc/ssh/ssh_host_ed25519_key -e devices/hildes-library/wifi.age
#
# Content:
#
#   WIFI_SSID=...
#   WIFI_PSK=...
{ config, inputs, ... }:
{
  imports = [ inputs.agenix.nixosModules.default ];

  age.secrets.wifi.file = ./wifi.age;

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.age.secrets.wifi.path ];
    profiles.home = {
      connection = {
        id = "home";
        type = "wifi";
        autoconnect = true;
      };
      wifi = {
        ssid = "$WIFI_SSID";
        mode = "infrastructure";
      };
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = "$WIFI_PSK";
      };
      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };
}
