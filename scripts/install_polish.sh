#!/bin/bash
set -e

echo "=== Final Polish Installations ==="

# 1. Starship & fzf
echo "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

echo "Installing fzf..."
apt-get update -qq
apt-get install -y fzf

# 2. zjstatus (Zellij Plugin)
echo "Downloading zjstatus for Zellij..."
# We download it to the default user's directory, not root
USER_HOME=$(wslpath "$(wslvar USERPROFILE)" | sed 's/mnt\/c\/Users/home/')
# Wait, this is WSL Ubuntu. The default user is aman, home is /home/aman.
# Let's just use /home/aman hardcoded or get it dynamically from /etc/passwd if uid 1000.
USER_DIR="/home/aman"
mkdir -p "$USER_DIR/.config/zellij/plugins"
wget -qO "$USER_DIR/.config/zellij/plugins/zjstatus.wasm" "https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm"
chown -R aman:aman "$USER_DIR/.config/zellij/plugins"

echo "=== Final Polish Complete ==="
