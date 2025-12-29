{
  description = "Ahnaf Rafi's dotfiles with nix-darwin and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs = {
    self, nixpkgs, nix-darwin, neovim-nightly, emacs-overlay,
    nix-homebrew, homebrew-core, homebrew-cask, ...
  }@inputs:
  let
    configuration = { config, lib, pkgs, ... }: {
      nix = {
       enable = false;
       nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      };
      # services.nix-daemon.enable = true;
      nixpkgs = {
        hostPlatform = "aarch64-darwin";
        overlays = [
          inputs.neovim-nightly.overlays.default
          inputs.emacs-overlay.overlays.default
        ];
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };

      programs.man.enable = true;
      documentation.man.enable = true;

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
        pkgs.libgccjit
        pkgs.llvmPackages.clang
        pkgs.cctools
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
        ((pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (
          epkgs: [
            epkgs.gcmh
            epkgs.exec-path-from-shell
            epkgs.nerd-icons
            epkgs.hl-todo
            epkgs.which-key
            epkgs.evil
            epkgs.evil-collection
            epkgs.evil-escape
            epkgs.general
            epkgs.dashboard
            epkgs.doom-modeline
            epkgs.procress
            epkgs.nerd-icons-ibuffer
            epkgs.vertico
            epkgs.consult
            epkgs.marginalia
            epkgs.orderless
            epkgs.corfu
            epkgs.cape
            epkgs.nerd-icons-completion
            epkgs.dirvish
            epkgs.nerd-icons-dired
            epkgs.helpful
            epkgs.elisp-demos
            epkgs.adaptive-wrap
            epkgs.evil-surround
            epkgs.yasnippet
            epkgs.evil-snipe
            epkgs.evil-traces
            epkgs.anzu
            epkgs.evil-anzu
            epkgs.magit
            epkgs.git-gutter
            epkgs.consult-eglot
            # TODO: Check if needed --- remove if not
            epkgs.treesit-auto
            epkgs.treesit-grammars.with-all-grammars
            # epkgs.treesit-grammars.with-grammars (g: [
            #   g.tree-sitter-nix
            #   g.tree-sitter-markdown
            #   g.tree-sitter-latex
            #   g.tree-sitter-typst
            #   g.tree-sitter-python
            #   g.tree-sitter-r
            #   g.tree-sitter-julia
            #   g.tree-sitter-c
            #   g.tree-sitter-cpp
            # ])
            epkgs.spell-fu
            # epkgs.flyspell-lazy
            # epkgs.flyspell-correct
            epkgs.vterm
            epkgs.pdf-tools
            epkgs.nov
            epkgs.olivetti
            epkgs.julia-mode
            epkgs.julia-ts-mode
            epkgs.julia-repl
            # TODO: Explore as possible replacement for julia-repl.
            # epkgs.julia-vterm
            epkgs.eglot-jl
            epkgs.ess
            epkgs.ess-view-data
            # TODO: Possibly consider the following for STATA highlighting
            # epkgs.ado-mode
            epkgs.lua-mode
            epkgs.nix-ts-mode
            epkgs.matlab-mode
            epkgs.vimrc-mode
            epkgs.typst-ts-mode
            epkgs.typst-preview
            epkgs.websocket
            epkgs.auctex
            epkgs.evil-tex
            epkgs.auctex-latexmk
            epkgs.auctex-cont-latexmk
            epkgs.auctex-label-numbers
            epkgs.preview-auto
            epkgs.preview-tailor
            epkgs.ebib
            epkgs.markdown-mode
            epkgs.polymode
            epkgs.poly-markdown
            epkgs.poly-R

            epkgs.nerd-icons-completion
            epkgs.nerd-icons-corfu
            epkgs.doom-themes
          ]
        ))

        neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default

        pkgs.texlive.combined.scheme-full
        pkgs.texlab
        pkgs.nixd
        pkgs.typst
        pkgs.tinymist
        pkgs.pandoc

        # pkgs.readstat

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

        pkgs.dbus
      ];

      # # Keep R from ever touching ~/Library/R/x.y
      # R_LIBS_USER = ""; # disable user library
      # R_ENVIRON_USER = "/dev/null";
      # R_PROFILE_USER = "/dev/null";

      # # Make Nix-provided libraries visible to compilers/linker.
      # # Nix wraps R, so this is often redundant, but helps for source builds.
      # NIX_CFLAGS_COMPILE = "-O1 -g -fno-omit-frame-pointer";
      # NIX_LDFLAGS = "";

      # # # Sanitizer defaults (you can toggle when you want)
      # # ASAN_OPTIONS = "detect_leaks=1,check_initialization_order=1";
      # # UBSAN_OPTIONS = "print_stacktrace=1,halt_on_error=1";

      # # Nice-to-have: keep PATH clean
      # shellHook = ''
      # echo ">> Using Nix R at: $(which R)"
      # echo ">> .libPaths() inside R should show only nix store paths."
      # echo ">> User site library disabled (R_LIBS_USER empty)."
      # '';

      # Ensure required runtime dirs + machine-id exist
      system.activationScripts.dbus.text = ''
        /bin/mkdir -p /var/run/dbus
    /bin/mkdir -p /var/lib/dbus
    ${pkgs.dbus}/bin/dbus-uuidgen --ensure=/var/lib/dbus/machine-id
      '';

      system.activationScripts.machineId.text = ''
        if [ ! -f /etc/machine-id ]; then
      ${pkgs.dbus}/bin/dbus-uuidgen --ensure=/etc/machine-id
    fi

    /bin/mkdir -p /var/lib/dbus
    /bin/ln -sf /etc/machine-id /var/lib/dbus/machine-id
      '';

      launchd.daemons.dbus = {
        command = "${pkgs.dbus}/bin/dbus-daemon --system --nofork --nopidfile";

        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;

          # Optional but common:
          StandardOutPath = "/var/log/dbus.log";
          StandardErrorPath = "/var/log/dbus.log";
        };
      };

      fonts.packages = [
        pkgs.julia-mono
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.symbols-only
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
          "/Applications/Nix Apps/Ghostty.app"
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
