{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;
in
{
  environment.systemPackages = [
    pkgs.unstable.ghostty-bin
    pkgs.unstable.ghostty-bin.terminfo
  ];

  home-manager.users.${username}.home.file.".terminfo/78/xterm-ghostty".source =
    "${pkgs.unstable.ghostty-bin.terminfo}/share/terminfo/78/xterm-ghostty";
}
