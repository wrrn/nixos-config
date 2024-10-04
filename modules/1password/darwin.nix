{
  lib,
  ...
}:
let
  inherit (lib) mkIf isDarwin;
in
{
  config = mkIf isDarwin (
    lib.warn ''
      `_1password_gui` will not be installed on Darwin.
       Please download it from:
      https://1password.com/downloads/mac
    '' { }
  );
}
