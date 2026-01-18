---
name: Quickstart
description: Full setup - configure env and start services
mode: terminal
---

```bash
# Create .env if it doesn't exist
if [ ! -f .env ]; then
  cp .env.example .env
  GENERATED_KEY=$(openssl rand -hex 32)
  sed -i '' "s/your-secret-key-here/$GENERATED_KEY/" .env
  echo "✅ Created .env with generated secret key"
else
  echo "✅ .env already exists"
fi

# Create logs directory
mkdir -p logs

# Start all services
./start.sh

echo ""
echo "🎉 HomeLab is running!"
echo "   Open WebUI: http://localhost:3000"
```
