{
  description = "A simple NixOS Configuration";
  inputs = {
    # Official flakes
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
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

    niri = {
      url = "github:sodiboo/niri-flake";
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
      niri,
      nur,
      zen-browser,

      dotfiles,
      fonts,
      wrrnpkgs,
      wrrnhosts,

    }@inputs:
    {
      nixosConfigurations = {
        alan-taylor = nixpkgs.lib.nixosSystem (import ./devices/alan-taylor inputs);
        fly-guy = nixpkgs.lib.nixosSystem (import ./devices/fly-guy inputs);
      };

      darwinConfigurations = {
        bandit = nix-darwin.lib.darwinSystem {
          modules = [
            ./devices/bandit
          ];
          specialArgs = {
            inherit inputs;
            system = "aarch64-darwin";
          };
        };

        boq = nix-darwin.lib.darwinSystem (import ./devices/boq inputs);
      };
    };
}
