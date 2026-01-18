#!/usr/bin/env bash
# Ensure Docker containers are running

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

SERVICE="openwebui"

# First ensure Docker Desktop is running
"$SCRIPT_DIR/ensure-docker-desktop.sh" || exit 1

echo "🐳 Checking Open WebUI container..."

# Use docker-compose from HOMELAB_HOME
cd "$HOMELAB_HOME"

# Check if container is already running
if docker compose ps --status running 2>/dev/null | grep -q "open-webui"; then
  log_info "$SERVICE" "Open WebUI already running at http://localhost:3000"
else
  echo "   Starting Open WebUI container..."
  if docker compose up -d >/dev/null 2>&1; then
    log_info "$SERVICE" "Open WebUI now running at http://localhost:3000"
  else
    log_error "$SERVICE" "Open WebUI failed to start"
    exit 1
  fi
fi
