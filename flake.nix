{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ neovim-nightly-overlay.overlay ];
      };
    in
    {
      nixosConfigurations.nixos =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            { nixpkgs = { inherit pkgs; }; }
            ./system/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.kid = import ./home.nix;
            }
          ];
        };
    };
}
