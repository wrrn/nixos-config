{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (pkgs.wrrn) voxtype;
in
{
  nixpkgs.overlays = [ inputs.wrrnpkgs.overlays.default ];

  users.users.${username}.extraGroups = [ "input" ];

  home-manager.users.${username} = {
    home.packages = [
      voxtype
      pkgs.wtype
    ];

    systemd.user.services.voxtype = {
      Unit = {
        Description = "Voxtype push-to-talk voice-to-text daemon";
        Documentation = "https://voxtype.io";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${voxtype}/bin/voxtype daemon";
        Restart = "on-failure";
        RestartSec = "5";
        # Ensure we have access to the display
        Environment = "XDG_RUNTIME_DIR=%t";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
