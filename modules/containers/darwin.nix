{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username}.home.packages = [
    pkgs.colima
  ];

  homebrew = {
    enable = true;
    brews = [
      "docker"
      "docker-compose"
      "docker-buildx"
    ];
  };
}
