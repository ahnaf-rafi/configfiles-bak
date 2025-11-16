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
    configuration = { config, lib, pkgs, ... }: {
      nix.enable = false;
      # services.nix-daemon.enable = true;
      nixpkgs.config.allowUnfree = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        let
          myRPackages = with pkgs.rPackages; [
            tidyverse
            ggplot2
            dplyr
            haven
            readxl
            knitr
            estimatr
            rstatix
            car
            sandwich
            AER
          ];

          myR = pkgs.rWrapper.override {
            packages = myRPackages;
          };

            # myRStudio = pkgs.rstudioWrapper.override {
            # packages = myRPackages;
            # };
        in
          [
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
            pkgs.brave

            pkgs.eza
            pkgs.bat
            pkgs.fd
            pkgs.ripgrep
            pkgs.fzf
            pkgs.wezterm
            pkgs.ghostty-bin
            pkgs.lazygit
            pkgs.delta
            ((pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (
              epkgs: [
                epkgs.gcmh
                epkgs.exec-path-from-shell
                epkgs.doom-themes
                epkgs.nerd-icons
                epkgs.vterm
                epkgs.pdf-tools
                epkgs.auctex
                epkgs.eglot-jl epkgs.julia-ts-mode
              ]
            ))

            neovim-nightly.packages.${pkgs.system}.default

            pkgs.texlive.combined.scheme-full
            pkgs.texlab
            pkgs.nixd
            pkgs.typst
            pkgs.tinymist
            pkgs.pandoc

            myR
            # myRStudio

            pkgs.readstat
            pkgs.maestral
            (pkgs.aspellWithDicts
              (dicts: with dicts; [ en en-computers en-science ]))
            pkgs.skimpdf
            # pkgs.zathura
            (pkgs.zathura.override {
              plugins = [ pkgs.zathuraPkgs.zathura_pdf_mupdf ];
            })
            pkgs.rectangle
            pkgs.sioyek

            pkgs.lynx
          ];

      fonts.packages = [
        pkgs.julia-mono
      ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";
        # onActivation = {
        # autoUpdate = true;
        # upgrade = true;
        # cleanup = "uninstall";
        # };

        taps = [];
        brews = [];
        casks = [];
      };

      # services.dbus.enable = true;

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
        NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
        NSGlobalDomain.NSTableViewDefaultSizeMode = 2;
        NSGlobalDomain.AppleShowAllExtensions = true;
        controlcenter.BatteryShowPercentage = true;
        controlcenter.Bluetooth = true;
        controlcenter.Sound = true;
        dock.magnification = true;
        dock.persistent-apps = [
          "/Applications/Google Chrome.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
          "/Applications/Nix Apps/Skim.app"
          "/Applications/Nix Apps/Emacs.app"
          "/Applications/Nix Apps/Wezterm.app"
          "/System/Applications/Utilities/Activity Monitor.app"
        ];
        finder.AppleShowAllExtensions = true;
        finder.AppleShowAllFiles = true;
        finder.FXPreferredViewStyle = "Nlsv";
        finder.FXRemoveOldTrashItems = true;
        finder.NewWindowTarget = "Home";
        finder.QuitMenuItem = true;
        finder.ShowPathbar = true;
        finder._FXSortFoldersFirst = true;
        finder._FXSortFoldersFirstOnDesktop = true;
        iCal.CalendarSidebarShown = true;
        iCal."TimeZone support enabled" = true;

        CustomUserPreferences = {
          # Figure out how to set default pdf viewer to Skim.
          # "com.apple.LaunchServices.OpenWith" = {
          # # This specifies the application to handle the public.pdf UTI.
          # "public.pdf" = {
          # # Use the bundle identifier you found earlier.
          # "net.sourceforge.skim-app.Skim" = true;
          # };
          # };

          "com.apple.HIToolbox" = {
            # Disable auto-enabling dictation
            AppleDicttionAutoEnable = 0;
          };
        };

      };

      system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };
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

              # Apple Silicon Only: Also install Homebrew under the default
              # Intel prefix for Rosetta 2
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
