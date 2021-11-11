{
  description = "kid's dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.05";
    home-manager.url = "github:nix-community/home-manager/release-21.05";

    # tell home-manager to use the flake version of nixpkgs
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86-64-linux";
    pkgs = import nixpkgs {
      inherit system;

      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;
  in {  
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;

        modules = [
          ./system/configuration.nix
        ];
      };
    };
  };
}
