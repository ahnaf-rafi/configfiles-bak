#!/bin/bash
set -e

echo "Setting up Nix dotfiles..."

# Clone repository if not already present
if [ ! -d "$HOME/configfiles" ]; then
    git clone https://github.com/ahnaf-rafi/configfiles.git "$HOME/configfiles"
fi

cd "$HOME/dotfiles"

# Detect system type
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Install nix-darwin if not present
    if ! command -v darwin-rebuild &> /dev/null; then
        echo "Installing nix-darwin..."
        nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
        ./result/bin/darwin-installer
    fi
    
    # Get hostname for configuration
    HOSTNAME=$(hostname -s)
    echo "Building configuration for $HOSTNAME..."
    
    # Build and switch
    darwin-rebuild switch --flake ".#$HOSTNAME"
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # NixOS setup
    sudo nixos-rebuild switch --flake ".#nixos-workstation"
fi

# Run stow to symlink config files
./scripts/stow-configs.sh

echo "Setup complete!"
