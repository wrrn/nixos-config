{ device-conf, inputs, ... }:
let
  inherit (device-conf) username;
  inherit (device-conf.platform) system;
  wrrnpkgs = inputs.wrrnpkgs.packages.${system};
in
{
  home-manager.users.${username}.home.packages = [ wrrnpkgs.claude-desktop ];
}
