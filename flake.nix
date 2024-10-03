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
    niri = {
      url = "github:sodiboo/niri-flake";
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

  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      flake-utils,
      niri,
      dotfiles,
      fonts,
      ...
    }@inputs:
    let
      systemInputs =
        system:
        nixpkgs.lib.mergeAttrs inputs {
          dotfiles = inputs.dotfiles.packages.${system};
          fonts = inputs.fonts.packages.${system};
        };
      modules = [
        ./options.nix
        ./modules/nix
        home-manager.nixosModules.home-manager
      ];
    in
    {
      nixosConfigurations = {
        redwall =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./devices/redwall

              niri.nixosModules.niri

              ./modules/1password
              ./modules/audio
              ./modules/coreutils
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

            ./modules/1password
            ./modules/coreutils
            ./modules/emacs
            ./modules/firefox
            ./modules/fonts
            ./modules/git
            ./modules/home-manager
            ./modules/keyboard
            ./modules/locale
            ./modules/networking
            ./modules/shell
            ./modules/user
          ] ++ modules
        }
      }
    };
}
