{ config, pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

    # Additional packages available to neovim
    extraPackages = with pkgs; [
      # Language servers
      lua-language-server
      nil # Nix LSP
      
      # Formatters
      # stylua
      nixpkgs-fmt
      
      # Other tools
      ripgrep
      fd
    ];
  };
}
