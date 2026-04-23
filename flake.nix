{
  description = "A simple NixOS Configuration";
  inputs = {
    # Official flakes
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };

    nixpkgs-staging = {
      url = "github:NixOS/nixpkgs/staging-next";
    };

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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

    paneru = {
      url = "github:karinushka/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "git+ssh://git@git.sr.ht/~warren/zen-browser-flake";
      # url = "path:/home/warren/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

    # Work flakes
    flaky-falcon = {
      # url = "path:/home/warren/flaky-falcon";
      # url = "git+ssh://git@git.sr.ht/~warren/flaky-falcon";
      url = "git+ssh://git@github.com/xonasystems/falcon-sensor-nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Personal flakes
    dotfiles = {
      url = "sourcehut:~warren/dotfiles/main";
      # url = "path:/home/warren/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fonts = {
      url = "git+ssh://git@git.sr.ht/~warren/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrrnpkgs = {
      url = "git+ssh://git@git.sr.ht/~warren/nixpkgs";
      # url = "path:/home/warren/nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.unstable.follows = "nixpkgs-unstable";
    };

    wrrnhosts = {
      # url = "git+ssh://git@git.sr.ht/~warren/hosts";
      url = "path:/Users/warrenharper/hosts";

      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-staging,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,

      flake-utils,
      niri,
      nur,
      paneru,
      zen-browser,

      flaky-falcon,

      dotfiles,
      fonts,
      wrrnpkgs,
      wrrnhosts,

    }@inputs:
    {
      nixosConfigurations = {
        alan-taylor = nixpkgs.lib.nixosSystem (import ./devices/alan-taylor inputs);
        fly-guy = nixpkgs.lib.nixosSystem (import ./devices/fly-guy inputs);
        lona = nixpkgs.lib.nixosSystem (import ./devices/lona inputs);
        nix-builder = nixpkgs.lib.nixosSystem (import ./devices/nix-builder inputs);
      };

      darwinConfigurations = {
        bandit = nix-darwin.lib.darwinSystem (import ./devices/bandit inputs);
        boq = nix-darwin.lib.darwinSystem (import ./devices/boq inputs);
      };
    };
}
