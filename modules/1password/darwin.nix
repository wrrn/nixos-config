{
  lib,
  pkgs,
  system,
  ...
}:
let
  inherit (lib) mkIf optionalAttrs warn;
  inherit (lib.systems.inspect) predicates;
  inherit (pkgs.stdenv) isDarwin;
in
{
  config = mkIf isDarwin {
    homebrew = {
      enable = true;
      casks = [
        "1password"
      ];
    };
  };
}
