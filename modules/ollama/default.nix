{ device-conf, ... }:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username}.services.ollama = {
    enable = true;
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "8h";
      # TODO: Add GPU specs to the device-conf
      # OLLAMA_VULKAN = "1";
    };
  };
}
