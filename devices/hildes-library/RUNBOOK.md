# hildes-library runbook

This runbook explains how to maintain and rebuild Emma's writing deck: a Dell
XPS 13 9360 that starts directly in LibreOffice Writer. The deck has no
terminal, browser, or login prompt, so you do all maintenance over SSH from
bandit. For the design and the decisions behind it, see the writer-deck thread
in `~/honeycomb/threads/writer-deck/`.

## Deck details

The following details are the ones you need most often:

- **SSH:** `root@DECK_IP`, using bandit's `~/.ssh/id_ed25519`. The deck
  accepts no passwords.
- **Host key fingerprint:** `SHA256:pJncnseHFGzYP5ET/d5pkTHvn3FdVLmYpe4UMLQdbDY`.
  The private key is in 1Password.
- **Wi-Fi MAC address:** `9c:b6:d0:f6:b0:c5`. To find `DECK_IP`, look up this
  MAC address on the Firewalla.
- **Emma's files:** `/home/emma/*.odt`. LibreOffice keeps the previously saved
  version of each file in `/home/emma/.config/libreoffice/4/user/backup/`.
- **Disk:** `nvme0n1`, with an EFI system partition labeled `boot` (vfat) and a
  root partition labeled `nixos` (ext4).
- **Builder:** bandit can't build x86_64-linux, so builds run on a remote
  host. Any x86_64-linux host with Nix and SSH access works. Your account on
  it doesn't need to be a Nix trusted user.

In the commands in this runbook, replace the following placeholders:

- `DECK_IP`: the deck's IP address.
- `BUILDER`: the SSH destination of the builder, for example
  `warren@builder.example.com`.

## Deploy a change

To build the configuration and install it on the deck, run the following
commands from `~/nixos-config` on bandit:

```sh
DECK=root@DECK_IP
B=ssh-ng://BUILDER
T=$(nix build --eval-store auto --store $B --print-out-paths --no-link \
  .#nixosConfigurations.hildes-library.config.system.build.toplevel)
nix copy --no-check-sigs --from $B --to ssh-ng://$DECK --substitute-on-destination $T
ssh $DECK "nix-env -p /nix/var/nix/profiles/system --set $T && $T/bin/switch-to-configuration boot"
ssh $DECK systemctl reboot
```

The commands work as follows:

- The `--no-check-sigs` flag is required because paths built on the builder
  are unsigned.
- `switch-to-configuration boot` followed by a reboot applies every change.
  Don't use `switch` instead: `switch` doesn't restart greetd, so session
  changes don't take effect until the next boot.
- The `--substitute-on-destination` flag makes the deck download packages from
  cache.nixos.org itself.

After the Firewalla rule blocks the deck's internet access, the deck can't
reach cache.nixos.org. Remove `--substitute-on-destination` from the `nix copy`
command so that every path streams from the builder through bandit. A nixpkgs
update can take a long time this way, because LibreOffice alone is about
1.5 GB.

### Roll back a change

If a change breaks the deck, do one of the following:

- At power-on, select the previous generation in the boot menu. The menu is
  shown for 5 seconds.
- Run the following command from bandit, and then restart the deck:

  ```sh
  ssh $DECK "nix-env -p /nix/var/nix/profiles/system --rollback && /nix/var/nix/profiles/system/bin/switch-to-configuration boot"
  ```

## Fix common problems

The following table lists problems that Emma might report and how to fix them:

| Problem | Fix |
|---|---|
| Writer stops responding or disappears. | Press <kbd>Control+Q</kbd>. Writer restarts within a second. If cage itself exits, greetd restarts the whole session. |
| Help fills the screen and has no close button. | Press <kbd>Control+W</kbd>. Windows have no title bars because cage runs with `-d`. |
| A dialog appears in the upper-left corner on a black screen. | No fix needed. The **Document Recovery** dialog and some message boxes appear there under cage, and they work normally. |
| Writer's toolbars or settings changed. | Reset the settings from the flake. See [Reset Writer's settings](#reset-writers-settings). |

### Reset Writer's settings

Resetting the settings deletes the profile's settings file and lets the system
copy in the version from the flake at the next boot. Emma's documents aren't
affected.

- Run the following command from bandit:

  ```sh
  ssh $DECK "systemctl stop greetd; rm /home/emma/.config/libreoffice/4/user/registrymodifications.xcu; systemctl reboot"
  ```

### Copy Emma's files to bandit

- Run the following command from bandit:

  ```sh
  scp "$DECK:/home/emma/*.odt" .
  ```

### Change the Wi-Fi network or password

The deck reads its Wi-Fi network name and password from an agenix secret.
Update the secret and deploy it before you change the router. If the deck
can't join the network, you lose SSH access to it.

1. From `~/nixos-config` on bandit, edit the secret:

   ```sh
   sudo nix run --inputs-from . agenix -- -i /etc/ssh/ssh_host_ed25519_key -e devices/hildes-library/wifi.age
   ```

   The secret contains two lines: `WIFI_SSID=NETWORK_NAME` and
   `WIFI_PSK=PASSWORD`. Enter the password as plain text.

1. Deploy the change. For instructions, see [Deploy a change](#deploy-a-change).
1. Change the router settings.

## Reinstall the deck

Reinstall the deck if its disk fails or its system can't start.

> **Warning:** Step 5 erases everything on the deck's disk, including Emma's
> files. If the disk is still readable, copy her files off first.

1. On the deck, start a NixOS 26.05 x86_64 installer from a USB drive. To pick
   the drive, press F12 at the Dell logo and select it under **UEFI**. Leave
   the USB drive connected until the installation finishes, because the live
   system reads its files from the drive.
1. On the deck, run `nmtui` and join the Wi-Fi network.
1. On the deck, run `passwd` to set a password for the `nixos` user, and then
   run `ip -4 a` to find the deck's IP address.
1. On bandit, run `ssh-copy-id nixos@DECK_IP`.
1. On the deck, erase the disk, partition it, and mount it:

   ```sh
   sudo wipefs -a /dev/nvme0n1
   sudo parted -s /dev/nvme0n1 -- mklabel gpt mkpart ESP fat32 1MiB 1GiB set 1 esp on mkpart nixos ext4 1GiB 100%
   sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p1
   sudo mkfs.ext4 -L nixos /dev/nvme0n1p2
   sudo mount /dev/disk/by-label/nixos /mnt
   sudo mount --mkdir -o umask=077 /dev/disk/by-label/boot /mnt/boot
   ```

1. Copy the host key from 1Password to `/mnt/etc/ssh/ssh_host_ed25519_key`,
   owned by root with mode `0600`, and its public key to
   `/mnt/etc/ssh/ssh_host_ed25519_key.pub` with mode `0644`. The deck needs
   this key to decrypt the Wi-Fi secret. If the key is lost, see
   [Replace a lost host key](#replace-a-lost-host-key).
1. On bandit, build the system and copy it to the live system's store. Follow
   [Deploy a change](#deploy-a-change) through the `nix copy` command, but use
   `DECK=nixos@DECK_IP`.
1. On the deck, install the system:

   ```sh
   sudo nixos-install --system STORE_PATH --no-root-passwd --no-channel-copy
   ```

   Replace `STORE_PATH` with the value of `$T` from the previous step.

1. Remove the USB drive and restart the deck. The deck starts in Writer, and
   SSH access is `root@DECK_IP` again.

### Replace a lost host key

If the host key isn't in 1Password, create a new key and re-encrypt the
secrets for it:

1. Create a key pair with `ssh-keygen -t ed25519 -N "" -C root@hildes-library -f ssh_host_ed25519_key`.
1. In `secrets.nix`, replace the `hildes-library` public key with the new one.
1. From `~/nixos-config` on bandit, re-encrypt the secrets:

   ```sh
   sudo nix run --inputs-from . agenix -- -i /etc/ssh/ssh_host_ed25519_key -r
   ```

1. Store the new private key in 1Password, and update the fingerprint in
   [Deck details](#deck-details).
