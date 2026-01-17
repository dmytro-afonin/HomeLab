#!/usr/bin/env bash
set -euo pipefail

# 1. keep the Mac awake (only if not already running)
if command -v caffeinate >/dev/null 2>&1; then
  if ! pgrep -x caffeinate >/dev/null; then
    caffeinate -s &
    echo "✅ Started caffeinate to keep Mac awake"
  else
    echo "✅ caffeinate already running"
  fi
else
  echo "⚠️  caffeinate not found, skipping keep-awake feature"
fi

# 2. start the LM Studio HTTP server (no GUI click required)
if command -v lms >/dev/null 2>&1; then
  # Check for "Server: ON" (not just "running" which matches "not running")
  if lms status 2>&1 | grep -q "Server: ON"; then
    echo "✅ LM Studio server already running"
  else
    echo "🧠 Starting LM Studio server (head-less) …"
    lms server start --port 1234 --bind 0.0.0.0 --cors || {
      echo "❌ Failed to start LM Studio server"
      exit 1
    }
  fi
else
  echo "⚠️  lms command not found, skipping LM Studio server start"
fi

# 3. ensure Docker Desktop is running (not stopped or paused)
DOCKER_STATUS=$(docker desktop status 2>&1 | grep -oE "running|paused|stopped" || echo "stopped")
if [[ "$DOCKER_STATUS" == "running" ]]; then
  echo "✅ Docker Desktop already running"
elif [[ "$DOCKER_STATUS" == "paused" ]]; then
  echo "🐋 Docker Desktop is paused – restarting …"
  docker desktop restart || {
    echo "❌ Failed to restart Docker Desktop"
    exit 1
  }
  echo "✅ Docker Desktop is ready"
else
  echo "🐋 Starting Docker Desktop …"
  docker desktop start || {
    echo "❌ Failed to start Docker Desktop"
    exit 1
  }
  echo "✅ Docker Desktop is ready"
fi

# 4. finally start your containers
echo "🐳  Starting containers via docker compose …"
if ! docker compose up -d; then
  echo "❌ Failed to start containers"
  exit 1
fi

echo "✅ All services started successfully"