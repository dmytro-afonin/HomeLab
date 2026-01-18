#!/usr/bin/env bash
# Ensure Docker Desktop is running

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

SERVICE="docker"

echo "🐋 Checking Docker Desktop..."

DOCKER_STATUS=$(docker desktop status 2>&1 | grep -oE "running|paused|stopped" || echo "stopped")

if [[ "$DOCKER_STATUS" == "running" ]]; then
  log_info "$SERVICE" "Docker Desktop already running"
elif [[ "$DOCKER_STATUS" == "paused" ]]; then
  echo "   Docker Desktop paused, restarting..."
  if docker desktop restart >/dev/null 2>&1; then
    log_info "$SERVICE" "Docker Desktop now running"
  else
    log_error "$SERVICE" "Docker Desktop failed to restart"
    exit 1
  fi
else
  echo "   Starting Docker Desktop..."
  if docker desktop start >/dev/null 2>&1; then
    log_info "$SERVICE" "Docker Desktop now running"
  else
    log_error "$SERVICE" "Docker Desktop failed to start"
    exit 1
  fi
fi
