#!/usr/bin/env bash
# Stop LM Studio server

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

SERVICE="lmstudio"

if command -v lms >/dev/null 2>&1; then
  if lms server stop 2>/dev/null; then
    log_info "$SERVICE" "Server stopped"
  else
    log_warn "$SERVICE" "Server was not running"
  fi
else
  log_warn "$SERVICE" "lms command not found"
fi
