{
  lib,
  ...
}:
{
  imports = [
    (lib.systemModule {
      linux = ./linux.nix;
      darwin = ./darwin.nix;
    })
  ];
}
