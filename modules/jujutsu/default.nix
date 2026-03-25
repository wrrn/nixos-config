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
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
in
{
  environment.systemPackages = [
    pkgs.difftastic # Difftool that uses AST
    pkgs.mergiraf # Merge tool that is syntax aware
    pkgs.unstable.jujutsu
    wrrnpkgs.jw
  ];

  home-manager.users.${username} = {
    programs.jujutsu = {
      enable = true;
      package = pkgs.unstable.jujutsu;
      ediff = false;
    };

    home = {
      packages = [
        pkgs.difftastic
        pkgs.delta
        wrrnpkgs.jw
      ];

      file.dot-jj = {
        target = ".config/jj";
        source = "${dotfiles.jj}/.config/jj";
        recursive = true;
      };
    };
  };

}
