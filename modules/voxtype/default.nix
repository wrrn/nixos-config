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

  services.ollama = {
    enable = true;
    loadModels = [
      "gemma3:1b"
    ];
  };

  home-manager.users.${username} = {
    home.packages = [
      voxtype
      pkgs.wtype
      pkgs.ollama
    ];

    systemd.user.services.voxtype = {
      Unit = {
        Description = "Voxtype push-to-talk voice-to-text daemon";
        Documentation = "https://voxtype.io";
        PartOf = [ "graphical-session.target" ];
        After = [
          "graphical-session.target"
          "wayland-ready.service"
        ];
        Wants = [ "wayland-ready.service" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${voxtype}/bin/voxtype daemon";
        Restart = "on-failure";
        RestartSec = "5";
        Environment = [
          "XDG_RUNTIME_DIR=%t"
        ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
