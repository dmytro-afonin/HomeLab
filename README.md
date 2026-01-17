# HomeLab

A streamlined way to run [Open WebUI](https://openwebui.com/) with [LM Studio](https://lmstudio.ai/) on macOS.

## Why This Setup?

### LM Studio + MLX = Native Apple Silicon Performance

[LM Studio](https://lmstudio.ai/) uses **MLX** — Apple's machine learning framework optimized for Apple Silicon. This means:

- **Native M1/M2/M3/M4 acceleration** — runs models directly on the Neural Engine and GPU
- **Unified memory architecture** — no VRAM limits, use all your RAM for larger models
- **Energy efficient** — better performance per watt than CUDA alternatives
- **No Docker overhead for inference** — LM Studio runs natively on macOS

### Open WebUI = Beautiful Chat Interface

[Open WebUI](https://openwebui.com/) provides a polished ChatGPT-like interface that connects to your local LM Studio server.

### This Script = Zero Friction

One command starts everything. Auto-start on login. Auto-updates. No manual steps.

## What This Does

The `start.sh` script:

1. **Keeps your Mac awake** — runs `caffeinate` to prevent sleep during inference
2. **Starts LM Studio server** — launches the headless LLM server if not already running
3. **Starts Docker Desktop** — ensures Docker is running (handles paused/stopped states)
4. **Runs Open WebUI** — starts the web interface container via `docker compose`

## Prerequisites

Install these first:

1. **macOS** (Sonoma/Sequoia on Apple Silicon recommended)
2. **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** — installed and working
3. **[LM Studio](https://lmstudio.ai/)** — with:
   - CLI enabled (LM Studio → Settings → Enable CLI)
   - At least one model downloaded (MLX or GGUF format)

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

### Auto-Start on Login (Optional)

```bash
./install-launchagent.sh
```

This generates a LaunchAgent with your local paths and loads it.

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
3. Add OpenAI API → Paste the copied URL

> **Note**: Use the local-network address from LM Studio (not `localhost`) so Docker can reach it.

### Update Schedule

Watchtower updates Open WebUI daily at 2 AM. Change in `docker-compose.yml`:

```yaml
WATCHTOWER_SCHEDULE=0 0 2 * * *  # cron format
```

### Remote Access (Optional)

To access Open WebUI outside your home network, use [ngrok](https://ngrok.com/):

1. Install the [ngrok Docker extension](https://hub.docker.com/extensions/ngrok/ngrok-docker-extension) in Docker Desktop
2. Create a tunnel to `localhost:3000`

> **Security note**: Enable authentication in Open WebUI before exposing externally.

## What's Included

| File | Purpose |
|------|---------|
| `start.sh` | Main startup script |
| `docker-compose.yml` | Open WebUI + Watchtower containers |
| `install-launchagent.sh` | Installs macOS LaunchAgent |
| `com.homelab.start.plist.template` | LaunchAgent template |
| `.env.example` | Environment template |
| `.cursor/commands/` | Cursor IDE commands |
| `.cursor/rules/` | Cursor IDE rules |

### Cursor IDE Integration

This repo includes Cursor commands and rules to help with setup and troubleshooting:

- **`quickstart`** — full setup in one command
- **Workflow commands**: `ensure-caffeinate`, `ensure-lmstudio`, `ensure-containers`
- **Service commands**: start/stop/status for Docker, LM Studio, caffeinate
- **Utility commands**: `health-check`, `view-logs`, `generate-secret-key`

Access via **Cmd+Shift+P** → search for command name.

## Services

| Service | Port | Description |
|---------|------|-------------|
| Open WebUI | 3000 | Chat interface |
| LM Studio | 1234 | LLM inference (MLX/GGUF, native macOS) |
| Watchtower | — | Auto-updates containers |

## Troubleshooting

**"Chunk too big" error** — Increase `CHAT_STREAM_RESPONSE_CHUNK_MAX_BUFFER_SIZE` in `.env`

**LM Studio not starting** — Enable CLI in LM Studio → Settings

**Can't connect to LM Studio** — Copy the URL from LM Studio menu bar (not `localhost`)

**Check logs:**
```bash
cat logs/start.log logs/start.error.log  # startup logs
docker compose logs -f                    # container logs
```

## Links

- [LM Studio](https://lmstudio.ai/) — Local LLM with MLX support
- [Open WebUI](https://openwebui.com/) / [Docs](https://docs.openwebui.com/)
- [MLX](https://github.com/ml-explore/mlx) — Apple's ML framework
- [ngrok Docker Extension](https://hub.docker.com/extensions/ngrok/ngrok-docker-extension)

## License

MIT
