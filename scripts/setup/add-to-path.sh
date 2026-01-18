#!/usr/bin/env bash
# Add hl command to PATH

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOMELAB_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$HOMELAB_ROOT/scripts/lib/log.sh"

SERVICE="setup"
HL_PATH="$HOMELAB_ROOT/hl"

echo "Choose installation method:"
echo "  1) Symlink to /usr/local/bin (recommended, requires sudo)"
echo "  2) Add to ~/.zshrc"
echo "  3) Add to ~/.bashrc"
echo ""
read -p "Enter choice [1-3]: " choice

case $choice in
  1)
    log_start "$SERVICE" "Creating symlink..."
    sudo ln -sf "$HL_PATH" /usr/local/bin/hl
    log_info "$SERVICE" "Symlink created: /usr/local/bin/hl"
    echo ""
    echo "You can now use 'hl' from anywhere!"
    ;;
  2)
    log_start "$SERVICE" "Adding to ~/.zshrc..."
    echo "" >> ~/.zshrc
    echo "# HomeLab CLI" >> ~/.zshrc
    echo "export PATH=\"$HOMELAB_ROOT:\$PATH\"" >> ~/.zshrc
    log_info "$SERVICE" "Added to ~/.zshrc"
    echo ""
    echo "Run 'source ~/.zshrc' or restart terminal to use 'hl'"
    ;;
  3)
    log_start "$SERVICE" "Adding to ~/.bashrc..."
    echo "" >> ~/.bashrc
    echo "# HomeLab CLI" >> ~/.bashrc
    echo "export PATH=\"$HOMELAB_ROOT:\$PATH\"" >> ~/.bashrc
    log_info "$SERVICE" "Added to ~/.bashrc"
    echo ""
    echo "Run 'source ~/.bashrc' or restart terminal to use 'hl'"
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac
