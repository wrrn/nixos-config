_: {
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.luks.devices."luks-9e4dc180-7843-4cf7-83fb-5f4f3cc7941f".device = "/dev/disk/by-uuid/9e4dc180-7843-4cf7-83fb-5f4f3cc7941f";
  };
}
