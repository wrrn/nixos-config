{
  description = "Home Manager configuration of warrenharper";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles.url = "sr.ht:warren/dotfiles/master"
  };

  outputs = { nixpkgs, home-manager, dotfiles, ... }:
    let
      ## TODO manage multiple systems
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      dotfiles = dotfiles.packages.${system};
    in {
      homeConfigurations."warrenharper" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          dotfiles = dotfiles;
        }
        
      };
    };
}
