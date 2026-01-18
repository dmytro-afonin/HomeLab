#!/usr/bin/env bash
# Ensure LM Studio server is running

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

SERVICE="lmstudio"

echo "🧠 Checking LM Studio server..."

if command -v lms >/dev/null 2>&1; then
  if lms status 2>&1 | grep -q "Server: ON"; then
    log_info "$SERVICE" "LM Studio server already running"
  else
    echo "   Starting LM Studio server..."
    if lms server start --port 1234 --bind 0.0.0.0 --cors >/dev/null 2>&1; then
      log_info "$SERVICE" "LM Studio server now running"
    else
      log_error "$SERVICE" "LM Studio server failed to start"
      exit 1
    fi
  fi
else
  log_warn "$SERVICE" "lms command not found"
fi
