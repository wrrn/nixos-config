{ device-conf, inputs, ... }:
let
  inherit (device-conf) username;
in
{
  homebrew = {
    enable = true;
    casks = [
      "gauntlet"
    ];
  };
}
