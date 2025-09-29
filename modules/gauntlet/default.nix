{ inputs, config, ... }:
let
  inherit (config.device-conf) username;
in
{
  homebrew = {
    enable = true;
    casks = [
      "gauntlet"
    ];
  };
}
