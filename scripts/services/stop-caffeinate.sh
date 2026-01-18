#!/usr/bin/env bash
# Stop caffeinate

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

SERVICE="caffeinate"

if pgrep -x caffeinate >/dev/null; then
  pkill -x caffeinate
  log_info "$SERVICE" "Stopped"
else
  log_warn "$SERVICE" "Was not running"
fi
