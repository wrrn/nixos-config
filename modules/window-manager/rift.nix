{ device-conf, inputs, ... }:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
in
{
  imports = [ inputs.rift.darwinModules.default ];
  services.rift = {
    enable = true;
    package = inputs.rift.packages.${system}.rift;
  };

  home-manager.users.${username}.wrrn.dotfiles.rift.enable = true;

  # Enable "Displays have separate spaced". It's kind of backward
  system.defaults.spaces.spans-displays = false;
}
