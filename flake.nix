{
  description = "A simple NixOS Configuration";
  inputs = {
    # Official flakes
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
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
      home-manager,
      flake-utils,
      niri,
      dotfiles,
      fonts,
      ...
    }@inputs:
    let
      inherit (flake-utils) systems;
      systemInputs =
        origInputs: system:
        nixpkgs.lib.mergeAttrs inputs {
          dotfiles = origInputs.dotfiles.packages.${system};
          fonts = origInputs.fonts.packages.${system};
        };
    in
    {
      nixosConfigurations = {
        redwall =
          let
            system = systems.x86_64-linux;
            inputs = systemInputs system;
          in
          nixpkgs.lib.nixosSystem {
            modules = [
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
            ];
            _module.args = {
              inputs = systemInputs;
            };
          };
      };
    };
}
#     {
#       nixosConfigurations.redwall = nixpkgs.lib.nixosSystem {
#         system = system;
#         modules = [
#           niri.nixosModules.niri
#           # lix.nixosModules.default
#           ./modules/1password
#           ./modules/audio
#           ./modules/emacs
#           ./modules/firefox
#           ./modules/fonts
#           ./modules/networking
#           ./modules/niri
#           ./modules/shell
#           ./modules/steam
#           ./modules/sddm
#           {
#             _module.args = {
#               inherit
#                 fonts
#                 unstable
#                 username
#                 dotfiles
#                 ;
#               inputs = newInputs;
#             };
#           }

#           home-manager.nixosModules.home-manager
#           {
#             home-manager.extraSpecialArgs = {
#               inherit
#                 dotfiles
#                 username
#                 fonts
#                 unstable
#                 ;
#               inputs = newInputs;
#         home-manager= users.warren = import ./home/default.nix;
# #               # Optionally, use home-manager.extraSpecialArgs to pass
# #               # arguments to home.nix
#             };
#           }
#         ];
#       };
#     };
# }
