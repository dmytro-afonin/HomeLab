---
name: View Startup Logs
description: View the HomeLab startup logs
mode: terminal
---

Display the startup logs:

```bash
echo "=== Standard Output ===" && cat logs/start.log && echo -e "\n=== Standard Error ===" && cat logs/start.error.log
```
