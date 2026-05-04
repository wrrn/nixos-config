{ device-conf, inputs, ... }:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${device-conf.platform.system};
in
{
  imports = [
    inputs.paneru.darwinModules.paneru
  ];
  services.paneru = {
    enable = true;
  };

  home-manager.users.${username}.home = {
    file.dot-rift = {
      source = "${dotfiles.paneru}/.config/paneru";
      target = ".config/paneru";
      recursive = true;
    };
  };

  # Enable "Displays have separate spaced". It's kind of backward
  system.defaults.spaces.spans-displays = true;
}
