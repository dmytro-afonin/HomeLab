---
name: Caffeinate Stop
description: Stop caffeinate and allow Mac to sleep normally
mode: terminal
---

Kill the caffeinate process:

```bash
pkill -x caffeinate && echo "✅ Stopped caffeinate" || echo "⚠️ caffeinate was not running"
```
