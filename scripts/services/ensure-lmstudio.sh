#!/usr/bin/env bash
# Ensure LM Studio server is running

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

SERVICE="lmstudio"

# Max wait time for lms CLI to become available (seconds)
MAX_WAIT=60
WAIT_INTERVAL=5

echo "🧠 Checking LM Studio server..."

# Wait for lms command to be available
wait_for_lms() {
  local waited=0
  
  while ! command -v lms >/dev/null 2>&1; do
    if [ $waited -ge $MAX_WAIT ]; then
      return 1
    fi
    
    if [ $waited -eq 0 ]; then
      echo "   Waiting for LM Studio to start..."
      log_info "$SERVICE" "Waiting for LM Studio CLI..."
    fi
    
    sleep $WAIT_INTERVAL
    waited=$((waited + WAIT_INTERVAL))
  done
  
  return 0
}

# Check if lms is available, wait if not
if ! command -v lms >/dev/null 2>&1; then
  # Try to open LM Studio app (it might not be running yet)
  if [ -d "/Applications/LM Studio.app" ]; then
    echo "   Opening LM Studio app..."
    open -a "LM Studio" 2>/dev/null || true
  fi
  
  # Wait for lms CLI to become available
  if ! wait_for_lms; then
    log_warn "$SERVICE" "LM Studio CLI not available after ${MAX_WAIT}s"
    echo "⚠️  LM Studio not ready (will retry on next start)"
    exit 0  # Don't fail, just warn
  fi
fi

# Now lms is available - check server status
if lms status 2>&1 | grep -q "Server: ON"; then
  log_info "$SERVICE" "LM Studio server already running"
  echo "✅ LM Studio server already running"
else
  echo "   Starting LM Studio server..."
  if lms server start --port 1234 --bind 0.0.0.0 --cors >/dev/null 2>&1; then
    log_info "$SERVICE" "LM Studio server now running"
    echo "✅ LM Studio server now running"
  else
    log_error "$SERVICE" "Failed to start LM Studio server"
    echo "❌ Failed to start LM Studio server"
    exit 1
  fi
fi
