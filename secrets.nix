let

  lona = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyK0OUTCSnEisggynWfUCBzjo/kKx14NMSaUX7Kkydv";
  bandit = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHqxiel6rRRg9u5UilhmLcRp9vuoNrtxbXDX+2nXvn3P";
  hildes-library = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGARhLLpxR9rqNfoYdtbGFdneDVtM33kGP5M2js4KjUU";
systems = [
    lona
    bandit
  ];
in
{
  "modules/pi/pi-search-keys.age" = {
    publicKeys = systems;
    armor = true;
  };
  "devices/hildes-library/wifi.age" = {
    publicKeys = [
      hildes-library
      bandit
    ];
    armor = true;
  };
}
