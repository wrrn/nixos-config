{
  device-conf,
  inputs,
  pkgs,
  config,
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
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "30m";
    };
    loadModels = [
      "gemma3:4b"
    ];
  };

  systemd.services.ollama-model-warmup = {
    description = "Load Ollama models into memory";
    after = [ "ollama-model-loader.service" ];
    requires = [ "ollama-model-loader.service" ];
    wantedBy = [ "multi-user.target" ];
    environment = config.systemd.services.ollama.environment;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ollama}/bin/ollama run gemma3:4b \"\"";
      RemainAfterExit = true;
    };
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
