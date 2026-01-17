---
name: Caffeinate Status
description: Check if caffeinate is running (keeping Mac awake)
mode: terminal
---

Check if caffeinate process is running:

```bash
pgrep -x caffeinate && echo "✅ caffeinate is running" || echo "❌ caffeinate is NOT running"
```
