{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  dotfiles = inputs.dotfiles.packages.${system};
in
{
  home-manager.users.${username} = {
    programs.starship.enable = true;
    home.file.starship = {
      source = "${dotfiles.starship}/.config/starship.toml";
      target = ".config/starship.toml";
    };
  };

}
