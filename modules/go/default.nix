{ device-conf, pkgs, ... }:
let
  inherit (device-conf) username;
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      go
      gopls
      gofumpt
      golangci-lint
      gotools
      delve
      gdlv
      kubebuilder
    ];
  };
}
