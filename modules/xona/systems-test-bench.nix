{ inputs, ... }:
{
  imports = [ inputs.xonapkgs.nixosModules.system-testing-bench ];
  xona.bench = {
    enable = true;
    networking = {
      # Give the USB ethernet adapter a stable name.
      interface = "bench0";
      # Matching on Driver rather than MACAddress is deliberate. This adapter
      # does not have a reliable hardware address.
      #
      # Driver matching holds as long as this is the only r8152 adapter on the
      # box. If a second one ever appears, switch to a Property match on the
      # USB idVendor/idProduct with the adapter plugged in to read them off.
      match.Driver = "r8152";
      address = "192.168.4.10";
      profileName = "testing-dhcp";
      openFirewall = true;
    };

    imagingKit = {
      port = 9191;
      dir = "/home/warren/loft/imaging-kit/kit";
    };
  };
}
