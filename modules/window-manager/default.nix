{ device-conf, inputs, ... }:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${device-conf.platform.system};
in
{
  imports = [ inputs.rift.darwinModules.default ];
  services.rift = {
    enable = true;
    package = inputs.rift.packages.${system}.rift;
  };

  home-manager.users.${username}.home = {
    file.dot-rift = {
      source = "${dotfiles.rift}/.config/rift";
      target = ".config/rift";
      recursive = true;
    };
  };

  # Enable "Displays have separate spaced". It's kind of backward
  system.defaults.spaces.spans-displays = false;
}
