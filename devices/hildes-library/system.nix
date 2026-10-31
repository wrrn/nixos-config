# Base system for the writer deck. Kept deliberately small: the lockdown comes
# from what isn't installed, so this host doesn't import the shared modules
# (nix, user, networking, ssh) that the other hosts use.
{ device-conf, ... }:
let
  inherit (device-conf) username displayName hostname;
in
{
  nixpkgs.hostPlatform = device-conf.platform.system;
  # Nothing on this host is unfree (linux-firmware and microcode are
  # redistributable), so allowUnfree stays at its default of false.

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
      # Keep the hardware MAC (Firewalla rule keys on it).
      wifi.macAddress = "permanent";
      # ath10k/QCA6174 power save causes disconnects.
      wifi.powersave = false;
    };
  };

  hardware.graphics.enable = true;
  fonts.enableDefaultPackages = true;

  users.mutableUsers = false;
  users.users.${username} = {
    isNormalUser = true;
    description = displayName;
    # Locked: the only way in is greetd's autologin.
    hashedPassword = "!";
  };

  # Admin access is SSH as root with Warren's key; no passwords anywhere.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPaSF9MPq9AyQtgnB+ReBPIfik9sMlufdMrHlNvJ464 warrenharper@bandit"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Closure trimming: speechd is on by default and pulls ~650 MB of voices;
  # the registry/NIX_PATH pin copies the nixpkgs source in.
  services.speechd.enable = false;
  nixpkgs.flake.setFlakeRegistry = false;
  nixpkgs.flake.setNixPath = false;
  environment.defaultPackages = [ ];
  documentation.enable = false;
}
