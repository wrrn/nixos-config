{ device-conf, inputs, ... }:
let
  inherit (device-conf) username;
  dotfiles = inputs.dotfiles.packages.${device-conf.platform.system};
in
{
  imports = [ inputs.paneru.darwinModules.paneru ];
  services.paneru = {
    enable = true;
    settings = null;
  };

  home-manager.users.${username}.home = {
    # services.paneru.enable = true;

    file.dot-paneru = {
      source = "${dotfiles.paneru}/.config/paneru";
      target = ".config/paneru";
      recursive = true;
    };
  };
}
