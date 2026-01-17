---
name: Generate Secret Key
description: Generate a secure random WEBUI_SECRET_KEY for Open WebUI
mode: terminal
---

Generate a secure random secret key for WEBUI_SECRET_KEY:

```bash
echo "WEBUI_SECRET_KEY=$(openssl rand -hex 32)"
```
