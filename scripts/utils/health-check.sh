#!/usr/bin/env bash
# Check health status of all HomeLab services

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

echo "=== HomeLab Health Check (v$HOMELAB_VERSION) ==="
echo ""

echo "☕ Caffeinate:"
if pgrep -x caffeinate > /dev/null; then
  echo "  ✅ Running"
else
  echo "  ❌ Not running"
fi

echo ""
echo "🧠 LM Studio:"
if command -v lms >/dev/null 2>&1; then
  lms status 2>&1 | head -5 | sed 's/^/  /'
else
  echo "  ⚠️  lms command not found"
fi

echo ""
echo "🐋 Docker Desktop:"
docker desktop status 2>&1 | sed 's/^/  /'

echo ""
echo "🐳 Docker Containers:"
docker compose ps 2>/dev/null | sed 's/^/  /' || echo "  ❌ Could not get container status"
