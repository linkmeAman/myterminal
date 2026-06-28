#!/bin/bash
set -e

echo "=== Developer Cockpit WSL Bootstrap ==="

# PATH setup
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# --- Install Starship ---
if ! command -v starship &>/dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "Starship already installed: $(starship --version)"
fi

# --- Install eza ---
if ! command -v eza &>/dev/null; then
    echo "Installing eza..."
    sudo apt-get install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt-get update -qq
    sudo apt-get install -y eza
else
    echo "eza already installed"
fi

# --- Install bat ---
if ! command -v bat &>/dev/null; then
    echo "Installing bat..."
    sudo apt-get install -y bat
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || true
else
    echo "bat already installed"
fi

# --- Install lazygit ---
if ! command -v lazygit &>/dev/null; then
    echo "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm -f lazygit lazygit.tar.gz
else
    echo "lazygit already installed"
fi

# --- Install Zellij ---
if ! command -v zellij &>/dev/null; then
    echo "Installing Zellij..."
    wget -q -O zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"
    tar -xf zellij.tar.gz
    sudo install zellij /usr/local/bin
    rm -f zellij zellij.tar.gz
else
    echo "Zellij already installed: $(zellij --version)"
fi

# --- Copy Zellij layouts from repo ---
mkdir -p ~/.config/zellij/layouts
cp /mnt/d/myterminal/zellij/layouts/*.kdl ~/.config/zellij/layouts/ 2>/dev/null && echo "Zellij layouts copied!" || echo "Warning: Could not find layouts at /mnt/d/myterminal/zellij/layouts/"

# --- Bootstrap .bashrc ---
if ! grep -q "Developer Cockpit Bootstrap" ~/.bashrc 2>/dev/null; then
    echo "Updating ~/.bashrc..."
    cat >> ~/.bashrc << 'EOF'

# === Developer Cockpit Bootstrap ===
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
eval "$(zoxide init bash)"
eval "$(starship init bash)"
command -v eza &>/dev/null && alias ls='eza --icons' && alias ll='eza --icons -la'
command -v bat &>/dev/null && alias cat='bat'
EOF
else
    echo ".bashrc already configured"
fi

echo ""
echo "=== Bootstrap Complete! ==="
echo "Installed tools:"
command -v starship &>/dev/null && echo "  ✅ starship $(starship --version)" || echo "  ❌ starship"
command -v eza &>/dev/null && echo "  ✅ eza" || echo "  ❌ eza"
command -v bat &>/dev/null && echo "  ✅ bat" || command -v batcat &>/dev/null && echo "  ✅ bat (batcat)" || echo "  ❌ bat"
command -v lazygit &>/dev/null && echo "  ✅ lazygit" || echo "  ❌ lazygit"
command -v zellij &>/dev/null && echo "  ✅ zellij $(zellij --version)" || echo "  ❌ zellij"
$HOME/.local/bin/zoxide --version &>/dev/null && echo "  ✅ zoxide" || echo "  ❌ zoxide"
echo ""
echo "Run: source ~/.bashrc  (or open a new WSL tab)"
