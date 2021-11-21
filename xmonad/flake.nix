{
  description = "A devShell example";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = github:numtide/flake-utils;
    xmonad = {
      url = github:xmonad/xmonad;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xmonad-contrib = {
      url = github:xmonad/xmonad-contrib;
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
            config.allowBroken = true;
          };
        in
        rec {
          devShell = pkgs.haskellPackages.shellFor {
            packages = p: [ p.kid-xmonad p.xmonad-contrib ];
            buildInputs = with pkgs.haskellPackages; [
              cabal-install
              cabal-fmt
              haskell-language-server
              hlint
              ghcid
              ormolu
              implicit-hie
              xmobar
            ];
          };
          # defaultPackage = pkgs.haskellPackages.xmonad-foo;
          defaultPackage = pkgs.haskellPackages.xmonad-kid.overrideAttrs (oa: rec {
            nativeBuildInputs = oa.nativeBuildInputs ++ [pkgs.makeWrapper];
            name = "xmonad-${system}";
            installPhase = oa.installPhase + ''
              ln -s ${pkgs.haskellPackages.xmobar}/bin/xmobar $out/bin/xmobar
              ln -s ${pkgs.haskellPackages.xmonad-kid}/bin/xmonad-kid $out/bin/xmonad-${system}
            '';
            postFixup = ''
              wrapProgram $out/bin/xmonad-${system} --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.haskellPackages.xmobar]}
            '';
          });
          # defaultPackage = (pkgs.haskellPackages.xmonad-foo (oa: {
          #   installPhase = oa.installPhase + ''
          #     ln -s ${pkgs.haskellPackages.xmobar} $out/bin/xmobar
          #   '';
          # }));
        }) // { inherit overlay overlays; };
}
