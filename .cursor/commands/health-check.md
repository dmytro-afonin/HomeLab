---
name: Health Check
description: Check the health status of all HomeLab services
mode: terminal
---

Check the status of all services:

```bash
echo "=== HomeLab Health Check ===" && \
echo "" && \
echo "☕ Caffeinate:" && \
(pgrep -x caffeinate > /dev/null && echo "  ✅ Running" || echo "  ❌ Not running") && \
echo "" && \
echo "🧠 LM Studio:" && \
(lms status 2>&1 | head -5 || echo "  ⚠️ lms command not found") && \
echo "" && \
echo "🐋 Docker Desktop:" && \
docker desktop status 2>&1 && \
echo "" && \
echo "🐳 Docker Containers:" && \
docker compose ps
```
