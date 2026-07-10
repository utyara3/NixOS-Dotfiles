{
  description = "utyara3 NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ayugram-desktop = {
      url = "github:ndfined-crp/ayugram-desktop";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

	specialArgs = { inherit inputs; };

	modules = [
	  ./nixos/hardware-configuration.nix
	  ./nixos/configuration.nix

	  inputs.home-manager.nixosModules.home-manager 
	  {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = { inherit inputs; };

	    home-manager.users.utyara3 = import ./home/home.nix;
	  }
	];
      };
    };
  };
}
