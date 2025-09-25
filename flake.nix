{
  description = "Ahnaf Rafi's dotfiles with nix-darwin and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{
    self, nixpkgs, nix-darwin, neovim-nightly,
    nix-homebrew, homebrew-core, homebrew-cask
  }:
  let
    configuration = { pkgs, ... }: {
      nix.enable = false;
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.coreutils
        pkgs.vim
        pkgs.git
        pkgs.curl
        pkgs.wget
        pkgs.stow
        pkgs.tmux
        pkgs.fontconfig
        pkgs.automake
        pkgs.autoconf
        pkgs.autogen
        pkgs.gcc
        pkgs.gnumake
        pkgs.libpng
        pkgs.zlib

        pkgs.eza
        pkgs.bat
        pkgs.fd
        pkgs.ripgrep
        pkgs.fzf
        pkgs.wezterm
        pkgs.lazygit
        pkgs.delta
        ((pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (
          epkgs: [ epkgs.vterm epkgs.pdf-tools epkgs.auctex ]
        ))
        neovim-nightly.packages.${pkgs.system}.default

        (pkgs.texlive.combine {
          inherit (pkgs.texlive)
          scheme-basic
          biber
          amsmath
          graphics
          hyperref
          tcolorbox;
        })
        pkgs.texlab
        pkgs.typst
        pkgs.tinymist
        pkgs.R
        pkgs.rstudio

        pkgs.maestral
        # pkgs.aspell
        (pkgs.aspellWithDicts
          (dicts: with dicts; [ en en-computers en-science ]))
        pkgs.skimpdf
        pkgs.zathura
        (pkgs.zathura.override {
          plugins = [ pkgs.zathuraPkgs.zathura_pdf_mupdf ];
        })
        pkgs.rectangle
      ];

      fonts.packages = [
        pkgs.julia-mono
      ];

      # programs.neovim = {
      # enable = true;
      # package = inputs.neovim-nightly.packages.${pkgs.system}.default;
      # };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before
      # changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      system.primaryUser = "ahnafrafi";

      system.defaults = {
        dock.autohide = true;
        finder.FXPreferredViewStyle = "clmv";
        NSGlobalDomain.AppleShowAllExtensions = true;
      };

      system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mb-air-work
    darwinConfigurations."mb-air-work" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel
            # prefix for Rosetta 2
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
            # With mutableTaps disabled, taps can no longer be added
            # imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
        # Optional: Align homebrew taps config with nix-homebrew
        ({config, ...}: {
         homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
      ];
    };
  };
}
