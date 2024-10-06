{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
  imports =
    [ ] ++ (lib.optionals isLinux [ ./linux.nix ]) ++ (lib.optionals isDarwin [ ./darwin.nix ]);
in
{
  inherit imports;
}
