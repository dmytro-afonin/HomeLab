#!/usr/bin/env bash
set -euo pipefail

# Install HomeLab LaunchAgent for auto-start on login

HOMELAB_PATH="$(cd "$(dirname "$0")" && pwd)"
source "$HOMELAB_PATH/scripts/lib/log.sh"

SERVICE="launchagent"
PLIST_NAME="com.homelab.start.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_PATH="$LAUNCH_AGENTS_DIR/$PLIST_NAME"

log_start "$SERVICE" "Installing HomeLab LaunchAgent..."

# Create logs directory
mkdir -p "$HOMELAB_PATH/logs"

# Unload existing agent if loaded
if launchctl list | grep -q "com.homelab.start"; then
  log_info "$SERVICE" "Unloading existing LaunchAgent"
  launchctl unload "$PLIST_PATH" 2>/dev/null || true
fi

# Generate plist from template
sed "s|{{HOMELAB_PATH}}|$HOMELAB_PATH|g" \
    "$HOMELAB_PATH/$PLIST_NAME.template" > "$PLIST_PATH"

log_info "$SERVICE" "Created $PLIST_PATH"

# Load the agent
if launchctl load "$PLIST_PATH"; then
  log_info "$SERVICE" "LaunchAgent loaded - will run on login"
else
  log_error "$SERVICE" "Failed to load LaunchAgent"
  echo "   Try: launchctl bootstrap gui/$(id -u) $PLIST_PATH"
  exit 1
fi

echo ""
echo "To uninstall: launchctl unload $PLIST_PATH"
