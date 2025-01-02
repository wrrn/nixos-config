{ config, pkgs, ... }:
let
  inherit (config.device-conf) username;

  holo-script = pkgs.writeShellApplication {
    name = "holo-script";
    runtimeInputs = [
      pkgs.steam
      pkgs.gamescope
    ];
    text = ''
      gamescope -f -r 60 -h 720 -F fsr -e -- steam
    '';
  };

  holo = pkgs.makeDesktopItem {
    name = "holo";
    desktopName = "Holo";
    exec = "${holo-script}/bin/holo-script";
  };
in
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  home-manager.users.${username} = {
    home.packages = [
      pkgs.itch
      holo
    ];
  };
}
