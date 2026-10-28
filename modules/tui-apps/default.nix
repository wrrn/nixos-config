{
  lib,
  ...
}:
{
  imports = [
    (lib.systemModule {
      linux = ./linux.nix;
    })
  ];
}
