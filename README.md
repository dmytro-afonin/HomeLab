# HomeLab

A startup script for running [Open WebUI](https://openwebui.com/) with [LM Studio](https://lmstudio.ai/) on macOS.

## What This Does

This repo provides a simple `start.sh` script that:

1. **Keeps your Mac awake** — runs `caffeinate` to prevent sleep during inference
2. **Starts LM Studio server** — launches the headless LLM server if not already running
3. **Starts Docker Desktop** — ensures Docker is running (handles paused/stopped states)
4. **Runs Open WebUI** — starts the web interface container via `docker compose`

Plus a macOS LaunchAgent to run everything automatically on login.

## Prerequisites

You need to install these yourself:

1. **macOS** (Sonoma/Sequoia recommended)
2. **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** — installed and working
3. **[LM Studio](https://lmstudio.ai/)** — installed with:
   - CLI enabled (LM Studio → Settings → Enable CLI)
   - At least one [GGUF model](https://huggingface.co/models?search=gguf) downloaded

## Quick Start

```bash
# Clone
git clone https://github.com/dmytro-afonin/HomeLab.git
cd HomeLab

# Configure
cp .env.example .env
openssl rand -hex 32  # Copy output to WEBUI_SECRET_KEY in .env

# Run
./start.sh
```

Open http://localhost:3000 and create your admin account.

## Configuration

### Environment Variables

Create `.env` from `.env.example`:

```env
# Generate with: openssl rand -hex 32
WEBUI_SECRET_KEY=your-secret-key-here

# Increase for fast models to avoid "chunk too big" error
CHAT_STREAM_RESPONSE_CHUNK_MAX_BUFFER_SIZE=10000
```

### Connecting Open WebUI to LM Studio

1. Click **LM Studio menu bar icon** → **Copy LLM Server Base URL**
2. In Open WebUI: **Admin Panel** → **Settings** → **Connections**
3. Add OpenAI API:
   - **URL**: Paste the copied URL

> **Note**: Docker containers can't access `localhost` directly — copy pasted local-network address routes to your Mac.

### Auto-Start on Login

```bash
# Enable
cp com.homelab.start.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.homelab.start.plist

# Disable
launchctl unload ~/Library/LaunchAgents/com.homelab.start.plist
```

### Update Schedule

Watchtower updates Open WebUI daily at 2 AM. Change in `docker-compose.yml`:

```yaml
WATCHTOWER_SCHEDULE=0 0 2 * * *  # cron format
```

### Remote Access (Optional)

To access Open WebUI outside your home network, you can use [ngrok](https://ngrok.com/):

1. Install the [ngrok Docker extension](https://hub.docker.com/extensions/ngrok/ngrok-docker-extension) in Docker Desktop
2. Open Docker Desktop → Extensions → ngrok
3. Sign in with your ngrok account
4. Create a tunnel to `localhost:3000`
5. Use the generated URL to access Open WebUI from anywhere

> **Security note**: Enable authentication in Open WebUI before exposing it externally.

## What's Included

| File | Purpose |
|------|---------|
| `start.sh` | Main startup script |
| `docker-compose.yml` | Open WebUI + Watchtower containers |
| `com.homelab.start.plist` | macOS LaunchAgent for auto-start |
| `.env.example` | Environment template |
| `.cursor/commands/` | Cursor IDE commands for common operations |
| `.cursor/rules/` | Cursor IDE rules for project context |

### Cursor IDE Integration

This repo includes Cursor commands and rules to help with setup and troubleshooting:

- **Workflow commands**: `ensure-caffeinate`, `ensure-lmstudio`, `ensure-containers`, `ensure-docker-desktop`
- **Service commands**: start/stop/status for Docker, LM Studio, caffeinate
- **Utility commands**: `health-check`, `view-logs`, `generate-secret-key`

Access via **Cmd+Shift+P** → search for command name.

## Services

| Service | Port | Description |
|---------|------|-------------|
| Open WebUI | 3000 | Chat interface |
| LM Studio | 1234 | LLM inference (via LM Studio app) |
| Watchtower | — | Auto-updates containers |

## Troubleshooting

**"Chunk too big" error** — Increase `CHAT_STREAM_RESPONSE_CHUNK_MAX_BUFFER_SIZE` in `.env`

**LM Studio not starting** — Enable CLI in LM Studio → Settings

**Can't connect to LM Studio** — Copy paste proper path from LM Studio (not localhost)

**Check logs:**
```bash
cat logs/start.log logs/start.error.log  # startup logs
docker compose logs -f                    # container logs
```

## Links

- [LM Studio](https://lmstudio.ai/)
- [Open WebUI](https://openwebui.com/) / [Docs](https://docs.openwebui.com/)
- [GGUF Models on Hugging Face](https://huggingface.co/models?search=gguf)
- [ngrok Docker Extension](https://hub.docker.com/extensions/ngrok/ngrok-docker-extension) — for remote access

## License

MIT
