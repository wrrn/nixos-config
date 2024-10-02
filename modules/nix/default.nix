_: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flasks feature and accompanying new nix cli.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
