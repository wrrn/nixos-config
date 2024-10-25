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

  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,

      flake-utils,
      niri,
      mac-app-util,

      dotfiles,
      fonts,
      wrrnpkgs,

    }@inputs:
    let
      systemInputs =
        system:
        nixpkgs.lib.mergeAttrs inputs {
          dotfiles = inputs.dotfiles.packages.${system};
        };
      inherit (flake-utils.lib) system;
    in
    {
      nixosConfigurations = {
        redwall = nixpkgs.lib.nixosSystem {
          modules = [
            ./devices/redwall
            {
              _module.args = {
                inputs = systemInputs system.x86_64-linux;
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        bandit = nix-darwin.lib.darwinSystem {
          modules = [
            ./devices/bandit
          ];
          specialArgs = {
            inputs = systemInputs system.aarch64-darwin;
          };
        };
      };
    };
}
