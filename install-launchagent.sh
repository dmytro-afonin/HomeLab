#!/usr/bin/env bash
set -euo pipefail

# Install HomeLab LaunchAgent for auto-start on login

HOMELAB_PATH="$(cd "$(dirname "$0")" && pwd)"
PLIST_NAME="com.homelab.start.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"

echo "📦 Installing HomeLab LaunchAgent..."

# Create logs directory
mkdir -p "$HOMELAB_PATH/logs"

# Generate plist from template
sed "s|{{HOMELAB_PATH}}|$HOMELAB_PATH|g" \
    "$HOMELAB_PATH/$PLIST_NAME.template" > "$LAUNCH_AGENTS_DIR/$PLIST_NAME"

echo "✅ Created $LAUNCH_AGENTS_DIR/$PLIST_NAME"

# Load the agent
launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_NAME"

echo "✅ LaunchAgent loaded and will run on login"
echo ""
echo "To uninstall: launchctl unload $LAUNCH_AGENTS_DIR/$PLIST_NAME"
