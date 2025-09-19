#!/bin/bash

cd "$HOME/dotfiles/config"

echo "Stowing configuration files..."

# Stow each configuration
stow .

echo "Configuration files stowed successfully!"
