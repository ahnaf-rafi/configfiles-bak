{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    # clock24 = true;
    # mouse = true;
    # terminal = "tmux-256color";
    # 
    # # Basic tmux configuration in Nix
    # extraConfig = ''
    #   # Load additional config from stow-managed files
    #   if-shell 'test -f ~/.config/tmux/tmux.conf' 'source-file ~/.config/tmux/tmux.conf'
    #   
    #   # Basic keybindings managed by Nix
    #   set -g prefix C-a
    #   bind C-a send-prefix
    #   unbind C-b
    # '';
    # 
    # plugins = with pkgs.tmuxPlugins; [
    #   sensible
    #   resurrect
    #   continuum
    # ];
  };
}
