#!/bin/bash
set -e

echo "=== LazyVim IDE Bootstrap ==="

# 1. Update and install core system utilities
echo "Installing core dependencies (ripgrep, fd-find, xclip, unzip, gcc, make)..."
sudo apt-get update -qq
sudo apt-get install -y ripgrep fd-find xclip unzip gcc make git curl wget

# Ubuntu's fd is often installed as fdfind, creating a symlink
mkdir -p ~/.local/bin
if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
    ln -s $(which fdfind) ~/.local/bin/fd
fi

# 2. Install Node.js v20 (Required for LSP/Copilot)
if ! command -v node &> /dev/null; then
    echo "Installing Node.js v20..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js already installed: $(node --version)"
fi

# 3. Install Neovim (Latest Stable)
if ! command -v nvim &> /dev/null; then
    echo "Installing Neovim (Stable)..."
    cd /tmp
    wget -qO nvim-linux64.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
    tar -xf nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo mv nvim-linux64 /opt/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    rm nvim-linux64.tar.gz
else
    echo "Neovim already installed: $(nvim --version | head -n 1)"
fi

# 4. Clone LazyVim Starter
echo "Setting up LazyVim..."
# Backup existing config if present
if [ -d "$HOME/.config/nvim" ] && [ ! -d "$HOME/.config/nvim.bak" ]; then
    echo "Backing up existing Neovim config to ~/.config/nvim.bak"
    mv ~/.config/nvim ~/.config/nvim.bak
elif [ -d "$HOME/.config/nvim" ]; then
    rm -rf ~/.config/nvim
fi

# Backup existing local data/state
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

echo ""
echo "=== LazyVim Bootstrap Complete ==="
nvim --version | head -n 1
node --version
rg --version | head -n 1
fd --version
