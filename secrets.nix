let

  lona = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyK0OUTCSnEisggynWfUCBzjo/kKx14NMSaUX7Kkydv";
  bandit = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHqxiel6rRRg9u5UilhmLcRp9vuoNrtxbXDX+2nXvn3P";
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
}
