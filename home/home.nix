{ config, pkgs, inputs, ... }:
{
  programs.home-manager.enable = true;
  home.username = "ahnafrafi";
  home.homeDirectory = /Users/ahnafrafi;
  home.stateVersion ="25.05";

  # User specific applications that shouldn't be available system-wide.
  home.packages = with pkgs; [
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

  # nixpkgs.overlays = [
  #   inputs.neovim-nightly.overlays.default
  # ];

  # programs.neovim = {
  #   enable = true;
  #   # package = inputs.neovim-nightly.packages.${pkgs.system}.default;
  # };

  # programs.zsh = {
  #   enable = true;
  #   enableBashCompletion = true;
  #   # autosuggestions.enable = true;
  #   syntaxHighlighting.enable = true;
  # };
}
