---
name: LaunchAgent Load
description: Load and enable the HomeLab LaunchAgent for auto-start
mode: terminal
---

Copy the plist to LaunchAgents and load it:

```bash
cp com.homelab.start.plist ~/Library/LaunchAgents/ && launchctl load ~/Library/LaunchAgents/com.homelab.start.plist
```
