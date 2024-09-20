{
  description = "Home Manager configuration for core utils";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/homemanager";
      input.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, home-manager, ... }:
    let
      system = builtins.currentSystem;
      pkgs = nixpkgs.legacyPackages.${system}
    in {
      homeConfigurations."warrenharper" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./default.nix
        ];

        
      };
    };
  }
