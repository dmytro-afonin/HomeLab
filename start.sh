#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export HOMELAB_HOME="${HOMELAB_HOME:-$SCRIPT_DIR}"

source "$SCRIPT_DIR/scripts/lib/log.sh"

log_start "startup" "HomeLab starting..."

# 1. Keep Mac awake
"$SCRIPT_DIR/scripts/services/ensure-caffeinate.sh"

# 2. Start LM Studio server
"$SCRIPT_DIR/scripts/services/ensure-lmstudio.sh"

# 3. Ensure Docker Desktop + containers are running
"$SCRIPT_DIR/scripts/services/ensure-containers.sh"

log_info "startup" "All services started successfully"
echo "✅ All services started successfully"
