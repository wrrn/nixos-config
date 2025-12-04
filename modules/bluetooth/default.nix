{
  device-conf,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  module = if device-conf.platform.isLinux then ./linux.nix else { };
in
{
  imports = [ module ];
  home-manager.users.${username}.home.packages = [ pkgs.bluetuith ];

}
