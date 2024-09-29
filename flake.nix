{
  description = "A simple NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles.url = "sourcehut:~warren/dotfiles/master";
    fonts.url = "git+ssh://git@git.sr.ht/~warren/fonts";
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      rev = "918d8340afd652b011b937d29d5eea0be08467f5";
      submodules = true;
    };

    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      dotfiles,
      fonts,
      unstable,
      niri,
      lix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "warren";
      dotfiles = inputs.dotfiles.packages.${system};
      fonts = inputs.fonts.packages.${system};
      unstable = import inputs.unstable { inherit system; };
      hyprland = inputs.hyprland.packages.${system};
      newInputs = nixpkgs.lib.mergeAttrs inputs {
        dotfiles = dotfiles;
        fonts = fonts;
        hyprland = hyprland;
      };
    in
    {
      nixpkgs.config.allowUnfree = true;
      nixosConfigurations.redwall = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          niri.nixosModules.niri
          lix.nixosModules.default
          ./configuration.nix
          ./modules/niri.nix
          ./modules/emacs.nix
          {
            _module.args = {
              inherit fonts unstable username;
              inputs = newInputs;
            };
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = ".bak";
            home-manager.users.warren = import ./home/default.nix;
            home-manager.extraSpecialArgs = {
              inherit
                dotfiles
                username
                fonts
                unstable
                ;
              inputs = newInputs;
              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            };
          }
        ];
      };
    };
}
