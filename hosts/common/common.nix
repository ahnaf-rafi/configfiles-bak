{ inputs, pkgs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  nixpkgs.config.allowUnfree = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # programs.fish.enable = true;
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Basic utilities
    coreutils
    vim
    git
    curl
    wget
    stow 

    # Terminal emulator
    ghostty
  ];

  # Fonts
  fonts.packages = with pkgs; [
    julia-mono
    nerd-fonts.jetbrains-mono
  ];
}
