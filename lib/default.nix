let
  moduleForSystem = import ./moduleForSystem.nix;
in
{
  extendLib = (
    lib: system:
    let
      systemModule = modules: moduleForSystem system modules;
    in
    lib.extend (
      final: prev: {
        inherit systemModule;
      }
    )
  );
}
