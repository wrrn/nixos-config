{
  device-conf,
  inputs,
  pkgs,
  ...
}:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
in
{
  programs.fish.enable = true;
  users.users.${username}.shell = pkgs.fish;
  environment.shells = [ pkgs.fish ];
  home-manager.users.${username} = {
    wrrn.dotfiles.fish.enable = true;
    home.packages = [
      pkgs.fishPlugins.tide
      pkgs.fishPlugins.done
      wrrnpkgs.tide-item-jj
    ];
  };
}
