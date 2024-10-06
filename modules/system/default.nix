{ lib, stdenv, ... }:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
  imports = [ ] ++ (lib.optionals isDarwin [ ./darwin.nix ]);
in
{
  inherit imports;
}
