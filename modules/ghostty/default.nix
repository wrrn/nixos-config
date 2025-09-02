{
  inputs,
  ...
}:
{
  ## Putting this here to prevent infinite recursion.
  ## TODO: Is there a better way.
  nixpkgs.overlays = [ inputs.wrrnpkgs.overlays.macApps ];
  imports = [
    ./darwin.nix
    ./linux.nix
  ];
}
