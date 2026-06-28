#!/bin/bash
set -e

echo "=== Developer Cockpit Ultimate Upgrades ==="

# 1. DevOps TUIs
echo "Installing lazydocker..."
cd /tmp
curl -s https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
if [ -f "$HOME/.local/bin/lazydocker" ]; then
    mv "$HOME/.local/bin/lazydocker" /usr/local/bin/
elif [ -f "./lazydocker" ]; then
    mv ./lazydocker /usr/local/bin/
fi

echo "Installing k9s..."
curl -sS https://webi.sh/k9s | sh
# Webi installs to ~/.local/bin/k9s, let's move it to /usr/local/bin for global access
if [ -f "$HOME/.local/bin/k9s" ]; then
    mv "$HOME/.local/bin/k9s" /usr/local/bin/
fi

# 2. GitHub CLI (gh)
if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI..."
    mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    apt-get update -qq
    apt-get install gh -y
else
    echo "GitHub CLI already installed."
fi

# 3. pre-commit
if ! command -v pre-commit &> /dev/null; then
    echo "Installing pre-commit..."
    apt-get install pre-commit -y
else
    echo "pre-commit already installed."
fi

echo "=== Upgrades Complete ==="
lazydocker --version || echo "lazydocker installed"
k9s version -s || echo "k9s installed"
gh --version | head -n 1
pre-commit --version
