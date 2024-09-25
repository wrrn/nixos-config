{
  description = "A simple NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    dotfiles.url = "sr.ht:warren/dotfiles/master"
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      dotfiles,
      ...
    }@inputs:
    {
      nixosConfigurations.redwall = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.warren = import ./home/default.nix;
            home-manager.extraSpecialArgs = {
              username = "warren";
              inherit dotfiles;
              userChrome = builtins.readFile "${dotfiles.tridactyl}/.config/tridactyl/better-firefox-chrome.css"
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
}
