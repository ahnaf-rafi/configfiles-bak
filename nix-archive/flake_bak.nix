{
  description = "Ahnaf Rafi's dotfiles with nix-darwin and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self, nixpkgs, nix-darwin, home-manager,
    nix-homebrew, homebrew-core, homebrew-cask,
    neovim-nightly-overlay, ...
  }:

  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;

# UNCOMMENT WHEN THE OTHER SCRIPTS ARE WRITTEN
# Import modular configurations
# imports = [
#   ./modules/system.nix
#   ./modules/homebrew.nix
#   ./modules/fonts.nix
#   ./modules/programs/git.nix
#   ./modules/programs/zsh.nix
# ];

# List packages installed in system profile. To search by name, run:
# $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.coreutils
          pkgs.vim
          pkgs.neovim
          pkgs.tmux
          pkgs.git
          pkgs.stow
          pkgs.fontconfig
          pkgs.ripgrep
          pkgs.fd
          pkgs.fzf
          pkgs.cargo
          pkgs.nodejs
          pkgs.tree-sitter
          pkgs.wezterm
          pkgs.ghostty
# pkgs.mkalias
# pkgs.emacs
      ];
      fonts.packages = [
        pkgs.julia-mono
      ];

# Necessary for using flakes on this system
      nix.settings.experimental-features = "nix-command flakes";


# Create /etc/zshrc that loads the nix-darwin environment
      programs.zsh.enable = true;

      system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };

# Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
            name = "system-applications";
            paths = config.environment.systemPackages;
            Applications = "/pathsToLink";
          };
        in
          pkgs.lib.mkForce ''
  # Set up applications.
  echo "setting up /Applications..." >&2
  rm -rf /Applications/Nix\ Apps
  mkdir -p /Applications/Nix\ Apps
  find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  while read -r src; do
    app_name=$(basename "$src")
    echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
  done
          '';

        # Used for backwards compatibility, please read the changelog before
        # changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#ECON-DYR5QNPF6C
      darwinConfigurations."ECON-DYR5QNPF6C" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "ahnafrafi";

              # Optional: Declarative tap management
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };

              # Optional: Enable fully-declarative tap management
              #
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = false;
            };
          }
        ];
      };
    };
}
