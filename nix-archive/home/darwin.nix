{ config, pkgs, inputs, ... }:

{
  imports = [
    ./common.nix
    ./programs/neovim.nix
    ./programs/tmux.nix
    ./programs/git.nix
    # ./programs/fzf.nix
    ./programs/zsh.nix
  ];

  # macOS-specific home configuration
  # home.packages = with pkgs; [
  #   # macOS-specific user packages
  # ];

  # macOS-specific settings
  # targets.darwin.defaults = {
  #   "com.apple.desktopservices" = {
  #     DSDontWriteNetworkStores = true;
  #     DSDontWriteUSBStores = true;
  #   };
  # };
}
