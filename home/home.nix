{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home.username = "ahnafrafi";
  home.homeDirectory = "/Users/ahnafrafi";

  # User specific applications that shouldn't be available system-wide.
  home.packages = [
    bat
    exa
    fd
    ripgrep
    fzf
    tmux
    lazygit
    delta
    gh

    # dropbox
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly
  };

}
