#!/bin/bash
set -e

echo "=== Deploying Developer Cockpit Dotfiles ==="

REPO_DIR="/mnt/d/myterminal"
DOTFILES_DIR="$REPO_DIR/dotfiles"

mkdir -p ~/.config/starship
mkdir -p ~/.config/zellij/layouts
mkdir -p ~/.config/nvim/lua/plugins

# 1. Starship
if [ -f "$DOTFILES_DIR/starship/starship.toml" ]; then
    cp "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml
    echo "Deployed Starship configuration."
fi

# 2. Zellij
if [ -f "$DOTFILES_DIR/zellij/config.kdl" ]; then
    cp "$DOTFILES_DIR/zellij/config.kdl" ~/.config/zellij/config.kdl
    echo "Deployed Zellij main config."
fi

if [ -f "$DOTFILES_DIR/zellij/layouts/default.kdl" ]; then
    cp "$DOTFILES_DIR/zellij/layouts/default.kdl" ~/.config/zellij/layouts/default.kdl
    echo "Deployed Zellij default layout."
fi

# 3. Neovim (LazyVim Catppuccin)
if [ -f "$DOTFILES_DIR/nvim/lua/plugins/colorscheme.lua" ]; then
    cp "$DOTFILES_DIR/nvim/lua/plugins/colorscheme.lua" ~/.config/nvim/lua/plugins/colorscheme.lua
    echo "Deployed Neovim colorscheme."
fi

echo "=== Dotfiles Deployment Complete ==="
