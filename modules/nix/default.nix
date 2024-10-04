{ pkgs, ... }:
{

  nixpkgs.config.allowUnfree = true;
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;

    # Enable the Flakes feature and accompanying new nix cli.
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

}
