#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export HOMELAB_HOME="${HOMELAB_HOME:-$SCRIPT_DIR}"

source "$SCRIPT_DIR/scripts/lib/log.sh"

# Initial delay for LaunchAgent startup (give other login items time to start)
# Set HOMELAB_STARTUP_DELAY=0 to skip
STARTUP_DELAY="${HOMELAB_STARTUP_DELAY:-10}"

if [ "$STARTUP_DELAY" -gt 0 ] 2>/dev/null; then
  log_info "startup" "Waiting ${STARTUP_DELAY}s for login items..."
  sleep "$STARTUP_DELAY"
fi

log_start "startup" "HomeLab starting..."

# 1. Keep Mac awake
"$SCRIPT_DIR/scripts/services/ensure-caffeinate.sh"

# 2. Start LM Studio server (waits for lms CLI if needed)
"$SCRIPT_DIR/scripts/services/ensure-lmstudio.sh"

# 3. Ensure Docker Desktop + containers are running
"$SCRIPT_DIR/scripts/services/ensure-containers.sh"

log_info "startup" "All services started successfully"
echo "✅ All services started successfully"
