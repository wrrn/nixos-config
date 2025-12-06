{ pkgs, ... }:
{
  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "bpf_jit_enable=1" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "kernel.unprivileged_bpf_disabled" = 0; # Try 0 instead of 1
      "net.core.bpf_jit_enable" = 1;
    };

    initrd.luks.devices."luks-9e4dc180-7843-4cf7-83fb-5f4f3cc7941f".device =
      "/dev/disk/by-uuid/9e4dc180-7843-4cf7-83fb-5f4f3cc7941f";
  };
}
