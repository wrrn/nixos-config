{
	description = "A simple NixOS Configuration";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
	};
	
	outputs = {self, nixpkgs, ...}@inputs: {
		nixosConfigurations.redwall = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
        ./home/default.nix
			];
		};
	};
}
