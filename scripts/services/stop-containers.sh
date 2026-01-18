#!/usr/bin/env bash
# Stop Docker containers

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

SERVICE="containers"

# Use docker-compose from HOMELAB_HOME
cd "$HOMELAB_HOME"

echo "🐳 Stopping Open WebUI container..."
if docker compose down >/dev/null 2>&1; then
  log_info "$SERVICE" "Open WebUI stopped"
else
  log_error "$SERVICE" "Failed to stop Open WebUI"
fi
