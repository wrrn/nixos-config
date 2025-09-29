{
  description = "A simple NixOS Configuration";
  inputs = {
    # Official flakes
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Third party flakes
    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    gauntlet = {
      url = "github:project-gauntlet/gauntlet";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "git+ssh://git@git.sr.ht/~warren/zen-browser-flake";
      # url = "path:/Users/warren.harper/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Personal flakes
    dotfiles = {
      url = "sourcehut:~warren/dotfiles/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fonts = {
      url = "git+ssh://git@git.sr.ht/~warren/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrrnpkgs = {
      url = "git+ssh://git@git.sr.ht/~warren/nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrrnhosts = {
      url = "git+ssh://git@git.sr.ht/~warren/hosts";
      # url = "path:/home/warren/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,

      flake-utils,
      gauntlet,
      niri,
      mac-app-util,
      nur,
      zen-browser,

      dotfiles,
      fonts,
      wrrnpkgs,
      wrrnhosts,

    }@inputs:
    let
      inherit (flake-utils.lib) system;
    in
    {
      nixosConfigurations = {
        alan-taylor = nixpkgs.lib.nixosSystem {
          modules = [
            ./devices/alan-taylor
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };

      darwinConfigurations = {
        bandit = nix-darwin.lib.darwinSystem {
          modules = [
            ./devices/bandit
          ];
          specialArgs = {
            inherit inputs;
          };
        };

        boq = nix-darwin.lib.darwinSystem {
          modules = [
            ./devices/boq
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
