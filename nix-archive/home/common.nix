{ config, pkgs, ... }:

{
  # Common user packages across all systems
  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    exa
    tree
    htop
  ];

  # Common home configuration
  home.username = "ahnafrafi";
  home.homeDirectory = if pkgs.stdenv.isDarwin 
    then "/Users/ahnafrafi" 
    else "/home/ahnafrafi";
  
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
