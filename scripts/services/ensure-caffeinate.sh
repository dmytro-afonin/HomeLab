#!/usr/bin/env bash
# Ensure caffeinate is running to keep Mac awake

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

SERVICE="caffeinate"

echo "☕ Checking caffeinate..."

if command -v caffeinate >/dev/null 2>&1; then
  if pgrep -x caffeinate >/dev/null; then
    log_info "$SERVICE" "caffeinate already running"
  else
    echo "   Starting caffeinate..."
    caffeinate -s &
    log_info "$SERVICE" "caffeinate now running"
  fi
else
  log_warn "$SERVICE" "caffeinate not found"
fi
