#!/bin/bash
set -e

echo "=== AIChat Installation ==="

# Get the latest release data from GitHub
LATEST_RELEASE=$(curl -s https://api.github.com/repos/sigoden/aichat/releases/latest)

# Extract the download URL for the x86_64 linux musl binary
DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | grep "browser_download_url.*x86_64-unknown-linux-musl.tar.gz" | cut -d '"' -f 4 | head -n 1)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Could not find the download URL. Trying GNU build..."
    DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | grep "browser_download_url.*x86_64-unknown-linux-gnu.tar.gz" | cut -d '"' -f 4 | head -n 1)
fi

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find a suitable Linux binary in the latest release."
    exit 1
fi

echo "Downloading from: $DOWNLOAD_URL"
cd /tmp
wget -qO aichat.tar.gz "$DOWNLOAD_URL"

echo "Extracting..."
tar -xzf aichat.tar.gz
# The tarball contains an 'aichat' executable

echo "Installing to /usr/local/bin..."
mv aichat /usr/local/bin/aichat
chmod +x /usr/local/bin/aichat

# Clean up
rm aichat.tar.gz

echo "=== AIChat Installed ==="
aichat --version
