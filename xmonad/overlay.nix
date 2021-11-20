_: pkgs: rec {
  haskellPackages = pkgs.haskellPackages.override (old: {
    overrides = pkgs.lib.composeExtensions (old.overrides or (_: _: { })) (self: super: rec {
      kid-xmonad = self.callCabal2nix "kid-xmonad"
        (
          pkgs.lib.sourceByRegex ./.
            [
              "xmonad.hs"
              "kid-xmonad.cabal"
              # "PagerHints.hs" "LICENSE"
            ]
        )
        { };
    });
  });
}
