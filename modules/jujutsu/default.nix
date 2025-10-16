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
  environment.systemPackages = with pkgs; [
    difftastic # Difftool that uses AST
    mergiraf # Merge tool that is syntax aware
    jujutsu
  ];

  home-manager.users.${username}.home.file.dot-jj = {
    target = ".config/jj";
    source = "${pkgs.dotfiles.jj}/.config/jj";
    recursive = true;
  };
}
