{
  description = "A simple NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles.url = "sourcehut:~warren/dotfiles/master";
    fonts.url = "git+ssh://git@git.sr.ht/~warren/fonts";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      dotfiles,
      fonts,
      unstable,
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
          ./configuration.nix
          {
            _module.args = {
              inherit fonts unstable;
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
