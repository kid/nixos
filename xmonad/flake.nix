{
  description = "A devShell example";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = github:numtide/flake-utils;
    xmonad = {
      url = github:xmonad/xmonad;
      # url = path:./xmonad;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xmonad-contrib = {
      url = github:xmonad/xmonad-contrib;
      # url = path:./xmonad-contrib;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, xmonad, xmonad-contrib }:
    let
      overlay = import ./overlay.nix;
      overlays = [ overlay xmonad.overlay xmonad-contrib.overlay ];
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system overlays;
          };
        in
        #   rec {
          #     devShell = mkShell {
          #       buildInputs = with pkgs.haskellPackages; [
          #         cabal-install
          #         haskell-language-server
          #         hlint
          #         ghcid
          #         ormolu
          #         implicit-hie
          #         xmonad
          #         xmonad-contrib
          #       ] ++ [ xorg.libX11 xorg.libXinerama xorg.libXext xorg.libXrandr xorg.libXScrnSaver ];
          #       # buildInputs = [
          #       #   haskellPackages.stack
          #       #   # haskellPackages.ghc
          #       #   haskellPackages.haskell-language-server
          #       #   # haskellPackages.hlint
          #       # ];
          #     };
          #   }
          # );
        rec {
          devShell = pkgs.haskellPackages.shellFor {
            packages = p: [ p.kid-xmonad p.xmonad-contrib ];
            buildInputs = with pkgs.haskellPackages; [
              cabal-install
              haskell-language-server
              hlint
              ghcid
              ormolu
              implicit-hie
            ];
          };
          defaultPackage = pkgs.haskellPackages.kid-xmonad;
        }) // { inherit overlay overlays; };
}
