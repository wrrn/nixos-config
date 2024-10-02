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
      systemInputs =
        system:
        nixpkgs.lib.mergeAttrs inputs {
          dotfiles = inputs.dotfiles.packages.${system};
          fonts = inputs.fonts.packages.${system};
        };
      modules = [
        ./options.nix
        ./nix-conf.nix
        niri.nixosModules.niri
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
    };
}
