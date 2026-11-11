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
  environment.systemPackages = [
    pkgs.difftastic # Difftool that uses AST
    pkgs.mergiraf # Merge tool that is syntax aware
    pkgs.unstable.jujutsu
  ];

  home-manager.users.${username} = {
    wrrn.dotfiles.jj.enable = true;

    programs.jujutsu = {
      enable = true;
      package = pkgs.unstable.jujutsu;
      ediff = false;
    };

    home = {
      packages = [
        pkgs.difftastic
        pkgs.delta
      ];
    };
  };

}
