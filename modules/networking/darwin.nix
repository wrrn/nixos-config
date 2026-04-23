{
  device-conf,
  ...
}:
let
  inherit (device-conf) hostname;
in
{
  networking = {
    computerName = hostname;
    localHostName = hostname;
  };
  wrrn.hosts.enable = true;
}
