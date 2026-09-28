{ ... }:
{
  # Give the USB ethernet adapter a stable name.
  #
  # Matching on Driver rather than MACAddress is deliberate. This adapter does
  # not have a reliable hardware address - the kernel logs
  #
  # Driver matching holds as long as this is the only r8152 adapter on the box.
  # If a second one ever appears, switch to a Property match on the USB
  # idVendor/idProduct with the adapter plugged in to read them off.
  #
  # .link files are processed by udev whether or not systemd-networkd is
  # enabled, so this works alongside NetworkManager.
  #
  # The name must stay out of the kernel's own namespace (eth*, enp*, wlan*);
  # systemd refuses those to avoid racing the kernel during renaming.
  systemd.network.links."10-bench-nic" = {
    matchConfig.Driver = "r8152";
    linkConfig.Name = "bench0";
  };
}
