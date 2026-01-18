#!/usr/bin/env bash
# Stop all HomeLab services

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

log_start "homelab" "Stopping all services…"

"$SCRIPT_DIR/stop-containers.sh"
"$SCRIPT_DIR/stop-lmstudio.sh"
"$SCRIPT_DIR/stop-caffeinate.sh"

log_info "homelab" "All services stopped"
