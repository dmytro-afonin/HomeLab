---
name: Stop All Services
description: Stop all HomeLab services (containers, LM Studio, caffeinate)
mode: terminal
---

Stop all HomeLab services:

```bash
echo "🛑 Stopping Docker containers..." && \
docker compose down && \
echo "🧠 Stopping LM Studio server..." && \
(lms server stop 2>/dev/null || echo "⚠️ LM Studio not running") && \
echo "💤 Stopping caffeinate..." && \
(pkill -x caffeinate 2>/dev/null || echo "⚠️ caffeinate not running") && \
echo "✅ All services stopped"
```
