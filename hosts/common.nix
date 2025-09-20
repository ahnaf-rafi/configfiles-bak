{ config, pkgs, inputs, ...}:

{

  nixpkgs.config.allowUnfree = true;

  # System-level packages (minimal)
  environment.systemPackages = [
    pkgs.vim
    pkgs.curl
    pkgs.wget
    pkgs.stow
  ];

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Overlay for neovim nightly
  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlay
  ];


  # Auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Used for backwards compatibility
  system.stateVersion = 4;
}
