{
  description = "Ahnaf Rafi's dotfiles with nix-darwin and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, neovim-nightly }:
  let
    configuration = { pkgs, ... }: {
      nix.enable = false;
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [ 
	pkgs.vim
	pkgs.git
	pkgs.curl
	pkgs.wget
	pkgs.stow
        pkgs.tmux

        pkgs.fontconfig
        
        pkgs.eza
        pkgs.bat
        pkgs.fd
        pkgs.ripgrep

        pkgs.fzf

        pkgs.wezterm

        neovim-nightly.packages.${pkgs.system}.default
      ];

      fonts.packages = [
        pkgs.julia-mono
      ];

      # programs.neovim = {
      #   enable = true;
      #   package = inputs.neovim-nightly.packages.${pkgs.system}.default;
      # };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mb-air-work
    darwinConfigurations."mb-air-work" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
