{ inputs, ... }:
{
  imports = [ inputs.xonapkgs.nixosModules.system-testing-bench ];
  xona.bench = {
    enable = true;
    networking = {
      # This matches the name of the interface defined in /devices/lona/bench-nic.nix
      interface = "bench0";
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
