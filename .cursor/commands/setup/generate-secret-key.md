---
name: Generate Secret Key
description: Generate a secure WEBUI_SECRET_KEY
mode: terminal
---

```bash
echo "WEBUI_SECRET_KEY=$(openssl rand -hex 32)"
```
