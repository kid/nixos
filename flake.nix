{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = github:nix-community/neovim-nightly-overlay;

    xmonad = {
      url = github:xmonad/xmonad;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xmonad-contrib = {
      url = github:xmonad/xmonad-contrib;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, xmonad, xmonad-contrib } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [
          neovim-nightly-overlay.overlay
          xmonad.overlay
          xmonad-contrib.overlay
          (import ./xmonad/overlay.nix)
        ];
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

          specialArgs = { inherit inputs; };
        };
    };
}
