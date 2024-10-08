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
      modules = [
        ./options.nix
        ./modules/nixos
        ./modules/nix
        ./modules/home-manager
      ];
      inherit (flake-utils.lib) system;
    in
    {
      nixosConfigurations = {
        redwall =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            modules = [
              {
                nixpkgs.hostPlatform = "x86_64-linux";
              }

              ./devices/redwall

              niri.nixosModules.niri
              home-manager.nixosModules.home-manager

              ./modules/1password
              ./modules/audio
              ./modules/emacs
              ./modules/firefox
              ./modules/fonts
              ./modules/git
              ./modules/home-manager
              ./modules/keyboard
              ./modules/locale
              ./modules/networking
              ./modules/niri
              ./modules/sddm
              ./modules/shell
              ./modules/steam
              ./modules/user

              {
                _module.args = {
                  inputs = systemInputs system;
                };
              }
            ] ++ modules;
          };
      };

      darwinConfigurations = {
        bandit = nix-darwin.lib.darwinSystem {
          modules = [
            ./devices/bandit

            home-manager.darwinModules.home-manager

            ./modules/1password
            ./modules/amethyst
            ./modules/apps
            ./modules/containers
            ./modules/emacs
            ./modules/firefox
            ./modules/fonts
            ./modules/git
            ./modules/keyboard
            ./modules/networking
            ./modules/shell
            ./modules/system
            ./modules/user

          ] ++ modules;
          specialArgs = {
            inputs = systemInputs system.aarch64-darwin;
          };
        };
      };
    };
}
