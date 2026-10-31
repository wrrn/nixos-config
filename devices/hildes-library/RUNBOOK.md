# hildes-library runbook

Emma's writing deck: a Dell XPS 13 9360 that boots straight into LibreOffice
Writer. There's no terminal, browser or login prompt on the deck; all
maintenance goes over SSH from bandit. Design and history:
`~/honeycomb/threads/writer-deck/`.

## Facts

| | |
|---|---|
| SSH | `root@<deck-ip>`, bandit's `~/.ssh/id_ed25519` only, no passwords |
| Host key | `SHA256:pJncnseHFGzYP5ET/d5pkTHvn3FdVLmYpe4UMLQdbDY` (private key in 1Password) |
| Wifi MAC | `9c:b6:d0:f6:b0:c5` (find the IP on the Firewalla) |
| Her files | `/home/emma/*.odt`; previous-save copies in `~/.config/libreoffice/4/user/backup/` |
| Disk | `nvme0n1`: ESP labelled `boot` (vfat), root labelled `nixos` (ext4) |
| Builder | Any x86_64-linux Nix host; `warren@gcp-exit-node` works without being trusted |

## Deploy a change

From `~/nixos-config` on bandit:

```sh
DECK=root@<deck-ip>
B=ssh-ng://warren@gcp-exit-node
T=$(nix build --eval-store auto --store $B --print-out-paths --no-link \
  .#nixosConfigurations.hildes-library.config.system.build.toplevel)
nix copy --no-check-sigs --from $B --to ssh-ng://$DECK --substitute-on-destination $T
ssh $DECK "nix-env -p /nix/var/nix/profiles/system --set $T && $T/bin/switch-to-configuration boot"
ssh $DECK systemctl reboot
```

- Use `boot` + reboot rather than `switch`: `switch` doesn't restart greetd, so
  session changes wouldn't take effect until the next boot anyway.
- `--no-check-sigs` because paths built on the builder are unsigned.
- **Once the Firewalla block is on**, the deck can't reach cache.nixos.org, so
  drop `--substitute-on-destination`; everything then streams through bandit
  (slow for a nixpkgs bump, since LibreOffice alone is about 1.5 GB). Otherwise,
  lift the rule for the duration of the update.
- To roll back: pick the previous generation in the boot menu (shown for 5 s
  at power-on), or `ssh $DECK "nix-env -p /nix/var/nix/profiles/system --rollback
  && /nix/var/nix/profiles/system/bin/switch-to-configuration boot"`.

## Common fixes

- **Writer frozen or gone**: Ctrl+Q. Writer restarts inside cage within a
  second; if cage itself died, greetd restarts the whole session.
- **Help filled the screen**: Ctrl+W. Windows have no title bars (`cage -d`).
- **Dialog in the top-left corner on a black screen** (Document Recovery,
  "no dictionary"): normal under cage; it still works.
- **Settings got messed up**: re-seed them from the flake. Her documents are
  untouched:
  `ssh $DECK "systemctl stop greetd; rm /home/emma/.config/libreoffice/4/user/registrymodifications.xcu; systemctl reboot"`
- **Copy her work off**: `scp "$DECK:/home/emma/*.odt" .`
- **New wifi network or password**: edit the secret, then deploy, **before**
  changing the router. Once the deck can't join, SSH is gone too.
  `sudo nix run --inputs-from . agenix -- -i /etc/ssh/ssh_host_ed25519_key -e devices/hildes-library/wifi.age`

## Reinstall from scratch

1. Boot any NixOS 26.05 x86_64 installer from USB (F12 at the Dell logo,
   choose the stick under UEFI). **Keep the stick in until the end**: the
   live system reads its store from it.
2. On the deck: `nmtui` to join wifi, `passwd` to give `nixos` a password,
   `ip -4 a` for the IP. On bandit: `ssh-copy-id nixos@<ip>`.
3. Wipe and partition (**erases the disk**):
   ```sh
   sudo wipefs -a /dev/nvme0n1
   sudo parted -s /dev/nvme0n1 -- mklabel gpt mkpart ESP fat32 1MiB 1GiB set 1 esp on mkpart nixos ext4 1GiB 100%
   sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p1
   sudo mkfs.ext4 -L nixos /dev/nvme0n1p2
   sudo mount /dev/disk/by-label/nixos /mnt
   sudo mount --mkdir -o umask=077 /dev/disk/by-label/boot /mnt/boot
   ```
4. Put the host key from 1Password at `/mnt/etc/ssh/ssh_host_ed25519_key`
   (root, 0600) and `.pub` (0644). Without it agenix can't decrypt the wifi
   secret. If the key is lost: generate a new one, put its public key in
   `secrets.nix` as `hildes-library`, re-encrypt with
   `sudo nix run --inputs-from . agenix -- -i /etc/ssh/ssh_host_ed25519_key -r`,
   and update the fingerprint above.
5. Build as in *Deploy a change*, but copy to `ssh-ng://nixos@<ip>` (the
   live system's store), then on the deck:
   `sudo nixos-install --system <T> --no-root-passwd --no-channel-copy`
6. Remove the stick and reboot. SSH is now `root@<ip>`.
