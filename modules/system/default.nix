{ lib, ... }: {
  imports = [
    (lib.systemModule { darwin = ./darwin.nix; linux = { }; })
  ];
}
