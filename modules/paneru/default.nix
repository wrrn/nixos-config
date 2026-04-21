{ inputs, ... }:
{
  imports = [ inputs.paneru.homeModules.paneru ];
  services.paneru = {
    enable = true;
    settings = null;
  };

  home-manager.users.${username}.home.file.dot-paneru = {
    source = "${dotfiles.paneru}/.config/paneru";
    target = ".config/paneru";
    recursive = true;
  };
}
