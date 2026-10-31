# Base system for the writer deck. Kept deliberately small: the lockdown comes
# from what isn't installed, so this host doesn't import the shared modules
# (nix, user, networking, ssh) that the other hosts use.
{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username displayName hostname;
in
{
  nixpkgs.hostPlatform = device-conf.platform.system;
  # Nothing on this host is unfree (linux-firmware and microcode are
  # redistributable), so allowUnfree stays at its default of false.

  # Early KMS: without it greetd can start cage while i915 is still replacing
  # simpledrm, and the autologin session dies on first boot.
  boot.initrd.kernelModules = [ "i915" ];

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

  # Nothing on the deck plays sound; 26.05 turns PipeWire on by default.
  services.pipewire.enable = false;

  # cage binds no keys, so the brightness keys need a system-level handler.
  # Floor of 375/7500 (5%) so the panel never goes fully dark.
  services.actkbd = {
    enable = true;
    bindings =
      let
        brightness = step: "${pkgs.brightnessctl}/bin/brightnessctl --min-value=375 set ${step}";
      in
      [
        {
          keys = [ 224 ]; # KEY_BRIGHTNESSDOWN
          events = [ "key" "rep" ];
          command = brightness "5%-";
        }
        {
          keys = [ 225 ]; # KEY_BRIGHTNESSUP
          events = [ "key" "rep" ];
          command = brightness "5%+";
        }
      ];
  };

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
