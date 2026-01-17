---
name: Ensure Containers Running
description: Check Docker Desktop status, start/restart if needed, then bring up containers
mode: terminal
---

Ensure Docker Desktop and containers are running (mirrors start.sh logic):

```bash
# Check Docker Desktop status
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

# Start containers
echo "🐳 Starting containers via docker compose …"
if ! docker compose up -d; then
  echo "❌ Failed to start containers"
  exit 1
fi

echo "✅ All containers started successfully"
```
