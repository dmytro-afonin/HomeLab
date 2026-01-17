---
name: Ensure Caffeinate Running
description: Check if caffeinate is running, start it only if needed
mode: terminal
---

Ensure Mac stays awake (mirrors start.sh logic):

```bash
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
```
