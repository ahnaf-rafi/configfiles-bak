{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    # Basic git configuration in Nix
    userName = "Ahnaf Rafi";
    userEmail = "ahnaf.al.rafi@gmail.com";
    
    # # Include additional config from stow-managed files
    # includes = [
    #   { path = "~/.gitconfig.local"; }
    # ];
    
    # Basic settings managed by Nix
    extraConfig = {
      init.defaultBranch = "main";
      # push.default = "simple";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };
}
