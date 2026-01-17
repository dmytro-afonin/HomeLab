---
name: LaunchAgent Unload
description: Unload and disable the HomeLab LaunchAgent
mode: terminal
---

Unload the LaunchAgent to disable auto-start:

```bash
launchctl unload ~/Library/LaunchAgents/com.homelab.start.plist
```
