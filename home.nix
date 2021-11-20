{ pkgs, lib, ... }:
{
  home.packages = with pkgs ; [
    htop
    kitty
    dmenu
    (chromium.override {
      commandLineArgs = [
        "--enable-features=WebUIDarkMode"
        "--force-dark-mode"
      ];
    })
    neovim-nightly
    rnix-lsp
    gcc
    git
    gh
    _1password-gui
    # pkgs.haskellPackages.xmobar
    tdesktop # telegram
    # haskellPackages.xmonad
    haskellPackages.kid-xmonad
    haskellPackages.xmobar
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.zsh = {
    enable = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
        { name = "plugins/fancy-ctrl-z"; tags = [ from:oh-my-zsh ]; }
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };
    plugins = [
      { name = "p10k-config"; src = lib.cleanSource ./configs; file = "p10k.zsh"; }
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };
  };

  programs.home-manager.enable = true;
}
