#!/usr/bin/env bash
set -euo pipefail

# HomeLab Installer
# Installs HomeLab CLI to ~/.homelab

REPO_URL="https://github.com/dmytro-afonin/HomeLab"
HOMELAB_HOME="$HOME/.homelab"

echo ""
echo "🏠 HomeLab Installer"
echo "===================="
echo ""
echo "This will install HomeLab to: $HOMELAB_HOME"
echo ""

# Check dependencies
echo "Checking dependencies..."

if ! command -v docker >/dev/null 2>&1; then
  echo "❌ Docker not found. Please install Docker Desktop first."
  echo "   https://www.docker.com/products/docker-desktop/"
  exit 1
fi
echo "✅ Docker found"

if ! command -v sqlite3 >/dev/null 2>&1; then
  echo "❌ sqlite3 not found. Please install it first."
  exit 1
fi
echo "✅ sqlite3 found"

# Required: LM Studio CLI
if command -v lms >/dev/null 2>&1; then
  echo "✅ LM Studio CLI found"
else
  echo "❌ LM Studio CLI not found"
  echo ""
  echo "   LM Studio is required for HomeLab."
  echo ""
  echo "   1. Install LM Studio: https://lmstudio.ai/"
  echo "   2. Open LM Studio at least once (registers CLI)"
  echo "   3. Enable CLI: Settings → Developer → Enable CLI"
  echo "   4. Enable headless: Settings → Developer → Enable Local LLM Service"
  echo ""
  exit 1
fi

echo ""

# Create directories
echo "Creating directories..."
mkdir -p "$HOMELAB_HOME"/{scripts/lib,scripts/services,scripts/logs,scripts/utils,scripts/setup,logs}

# Download or copy files
if [ -d "$(dirname "$0")/scripts" ]; then
  # Local install from repo
  echo "Installing from local repository..."
  cp -r "$(dirname "$0")"/scripts/* "$HOMELAB_HOME/scripts/"
  cp "$(dirname "$0")/hl" "$HOMELAB_HOME/"
  cp "$(dirname "$0")/start.sh" "$HOMELAB_HOME/"
  cp "$(dirname "$0")/VERSION" "$HOMELAB_HOME/"
  cp "$(dirname "$0")/docker-compose.yml" "$HOMELAB_HOME/"
  cp "$(dirname "$0")/.env.example" "$HOMELAB_HOME/"
  cp "$(dirname "$0")/com.homelab.start.plist.template" "$HOMELAB_HOME/"
  cp "$(dirname "$0")/install-launchagent.sh" "$HOMELAB_HOME/"
else
  # Remote install
  echo "Downloading from GitHub..."
  
  # Clone to temp directory
  TEMP_DIR=$(mktemp -d)
  git clone --depth 1 "$REPO_URL" "$TEMP_DIR"
  
  # Copy files
  cp -r "$TEMP_DIR"/scripts/* "$HOMELAB_HOME/scripts/"
  cp "$TEMP_DIR/hl" "$HOMELAB_HOME/"
  cp "$TEMP_DIR/start.sh" "$HOMELAB_HOME/"
  cp "$TEMP_DIR/VERSION" "$HOMELAB_HOME/"
  cp "$TEMP_DIR/docker-compose.yml" "$HOMELAB_HOME/"
  cp "$TEMP_DIR/.env.example" "$HOMELAB_HOME/"
  cp "$TEMP_DIR/com.homelab.start.plist.template" "$HOMELAB_HOME/"
  cp "$TEMP_DIR/install-launchagent.sh" "$HOMELAB_HOME/"
  
  # Cleanup
  rm -rf "$TEMP_DIR"
fi

# Make scripts executable
chmod +x "$HOMELAB_HOME/hl"
chmod +x "$HOMELAB_HOME/start.sh"
chmod +x "$HOMELAB_HOME"/scripts/**/*.sh 2>/dev/null || true
chmod +x "$HOMELAB_HOME"/scripts/*/*.sh 2>/dev/null || true
chmod +x "$HOMELAB_HOME/install-launchagent.sh"

# Create .env if not exists
if [ ! -f "$HOMELAB_HOME/.env" ]; then
  cp "$HOMELAB_HOME/.env.example" "$HOMELAB_HOME/.env"
  # Generate secret key
  SECRET_KEY=$(openssl rand -hex 32)
  sed -i '' "s/your-secret-key-here/$SECRET_KEY/" "$HOMELAB_HOME/.env"
  echo "✅ Created .env with generated secret key"
fi

# Create symlink
echo ""
echo "Adding 'hl' command to PATH..."
echo ""
echo "Choose installation method:"
echo "  1) Symlink to /usr/local/bin (recommended, requires sudo)"
echo "  2) Add to ~/.zshrc"
echo "  3) Skip (you can run $HOMELAB_HOME/hl directly)"
echo ""
read -p "Enter choice [1-3]: " choice

case $choice in
  1)
    sudo ln -sf "$HOMELAB_HOME/hl" /usr/local/bin/hl
    echo "✅ Symlink created"
    ;;
  2)
    echo "" >> ~/.zshrc
    echo "# HomeLab CLI" >> ~/.zshrc
    echo "export PATH=\"$HOMELAB_HOME:\$PATH\"" >> ~/.zshrc
    echo "✅ Added to ~/.zshrc (restart terminal or run: source ~/.zshrc)"
    ;;
  3)
    echo "Skipped. Run with: $HOMELAB_HOME/hl"
    ;;
esac

echo ""
echo "✅ Installation complete!"
echo ""
echo "Quick start:"
echo "  hl start          # Start all services"
echo "  hl status         # Check status"
echo "  hl help           # Show all commands"
echo ""
echo "Configuration: $HOMELAB_HOME/.env"
echo "Logs: $HOMELAB_HOME/logs/"
echo ""
