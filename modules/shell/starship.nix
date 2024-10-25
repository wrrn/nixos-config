{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) dotfiles;
  inherit (config.device-conf) username;
in
{
  nixpkgs.overlays = [ dotfiles.overlays.default ];

  home-manager.users.${username} = {
    programs.starship.enable = true;
    home.file.starship = {
      source = "${pkgs.dotfiles.starship}/.config/starship.toml";
      target = ".config/starship.toml";
    };
  };

}
