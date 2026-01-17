---
name: Ensure Docker Desktop Running
description: Check Docker Desktop status, start or restart based on current state
mode: terminal
---

Ensure Docker Desktop is running (handles running/paused/stopped states):

```bash
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
```
