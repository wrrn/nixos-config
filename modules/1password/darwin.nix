{
  lib,
  system,
  ...
}:
let
  inherit (lib) mkIf optionalAttrs warn;
  inherit (lib.systems.inspect) predicates;
  isDarwin = predicates.isDarwin system;
in
{
  config = mkIf isDarwin (
    warn ''
      `_1password_gui` will not be installed on Darwin.
       Please download it from:
      https://1password.com/downloads/mac
    '' { }
  );
}
