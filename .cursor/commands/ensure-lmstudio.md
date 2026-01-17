---
name: Ensure LM Studio Server Running
description: Check if LM Studio server is ON, start it only if needed
mode: terminal
---

Ensure LM Studio HTTP server is running (mirrors start.sh logic):

```bash
if command -v lms >/dev/null 2>&1; then
  if lms status 2>&1 | grep -q "Server: ON"; then
    echo "✅ LM Studio server already running"
  else
    echo "🧠 Starting LM Studio server (headless) …"
    lms server start --port 1234 --bind 0.0.0.0 --cors || {
      echo "❌ Failed to start LM Studio server"
      exit 1
    }
    echo "✅ LM Studio server started"
  fi
else
  echo "⚠️  lms command not found, skipping LM Studio server start"
fi
```
