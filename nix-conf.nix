_: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # Enable the Flakes feature and accompanying new nix cli.
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Speed up substitution: more parallel downloads and HTTP connections.
    http-connections = 50;
    max-substitution-jobs = 128;
  };
}
