{ device-conf, inputs, ... }:
let
  inherit (device-conf) username;
in
{
  imports = [
    inputs.paneru.darwinModules.paneru
  ];
  services.paneru = {
    enable = true;
    # init.lua loads config.fnl through Fennel
    extraLuaPackages = luaPs: [ luaPs.fennel ];
  };

  home-manager.users.${username}.wrrn.dotfiles.paneru.enable = true;

  # enable "displays have separate spaced". It's kind of backward
  system.defaults.spaces.spans-displays = false;
}
