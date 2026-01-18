# HomeLab

A CLI tool to run [Open WebUI](https://openwebui.com/) with [LM Studio](https://lmstudio.ai/) on macOS.

## Why This Setup?

### LM Studio + MLX = Native Apple Silicon Performance

[LM Studio](https://lmstudio.ai/) uses **MLX** — Apple's machine learning framework optimized for Apple Silicon:

- **Native M1/M2/M3/M4 acceleration** — runs on Neural Engine and GPU
- **Unified memory** — no VRAM limits, use all your RAM
- **Energy efficient** — better performance per watt
- **No Docker overhead for inference** — LM Studio runs natively

### Open WebUI = Beautiful Chat Interface

[Open WebUI](https://openwebui.com/) provides a polished ChatGPT-like interface connecting to your local LM Studio.

## Before You Install

Install these first — HomeLab won't work without them:

### 1. Docker Desktop

Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### 2. LM Studio

1. Download and install [LM Studio](https://lmstudio.ai/)
2. **Open LM Studio at least once** — this registers the `lms` CLI command
3. **Download a model** (e.g., Llama, Mistral, Qwen)
4. **Enable headless mode**: Settings → Developer → **Enable Local LLM Service**
   - This allows the LLM server to run without keeping the LM Studio window open

## Installation

### Quick Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/dmytro-afonin/HomeLab/main/install.sh | bash
```

Or clone and install:

```bash
git clone https://github.com/dmytro-afonin/HomeLab.git
cd HomeLab
./install.sh
```

This installs HomeLab to `~/.homelab/` and adds the `hl` command to your PATH.

### What Gets Installed

```
~/.homelab/
├── hl                     # CLI entry point
├── VERSION                # Version info
├── docker-compose.yml     # Container config
├── .env                   # Your configuration
├── scripts/               # All scripts
└── logs/                  # SQLite log database
```

## Usage

```bash
hl start          # Start all services
hl stop           # Stop all services
hl status         # Check status
hl logs           # View logs
hl help           # Show all commands
```

### Full Command Reference

```
hl <command> [options]

COMMANDS
    start [options]    Start all services
        --allow-sleep, -as       Don't prevent Mac from sleeping
        --allow-sleep-force, -asf  Also kill running caffeinate
    stop               Stop all services
    restart [options]  Restart all services
    status             Show status of all services

    logs [options]     View logs
        -n, --limit N      Show last N entries (default: 50)
        -s, --service NAME Filter by service
        -l, --level LEVEL  Filter by level (INFO, WARN, ERROR)
        --tail             Follow logs in real-time
        --stats            Show log statistics
        --clear            Clear all logs

    auto-start         Enable auto-start on login
    auto-start --off   Disable auto-start on login

    webui <command>    WebUI configuration
        buffer-size [N]      Set stream buffer size (default: 10 MB)
        list-env             Show current configuration
    ip                 Show local IP for network access
    open               Open WebUI in browser
    doctor [-v]        Check system requirements (-v for verbose)
    upgrade            Upgrade to latest version
    uninstall          Remove HomeLab completely
    version            Show version info
    help               Show this help
```

### Examples

```bash
hl start                      # Start everything
hl start --allow-sleep        # Start without caffeinate
hl status                     # Check all services
hl logs -n 100                # Last 100 log entries
hl logs --tail                # Follow logs live
hl auto-start                 # Enable auto-start on login
```

## Connecting Open WebUI to LM Studio

After starting services with `hl start`:

1. **Get LM Studio URL**:
   - Click the **LM Studio icon** in your Mac menu bar
   - Click **Copy LLM Server Base URL** (looks like `http://192.168.x.x:1234/v1`)

2. **Add to Open WebUI**:
   - Open [http://localhost:3000](http://localhost:3000)
   - Go to **Admin Panel** (top-right menu) → **Settings** → **Connections**
   - Under **OpenAI API**, click **+** to add a new connection
   - **URL**: Paste the URL from step 1
   - **API Key**: Enter anything (e.g., `lm-studio`) — LM Studio doesn't require a real key
   - Click **Save**

3. **Start chatting**: Your LM Studio models will now appear in the model selector

## Auto-Start on Login

```bash
hl auto-start          # Enable auto-start
hl auto-start --off    # Disable auto-start
```

## File Locations

| Path | Description |
|------|-------------|
| `~/.homelab/` | Installation directory |
| `~/.homelab/.env` | Configuration |
| `~/.homelab/logs/homelab.db` | SQLite logs |
| `~/Library/LaunchAgents/com.homelab.start.plist` | LaunchAgent (if installed) |

## Development

Clone the repo for development:

```bash
git clone https://github.com/dmytro-afonin/HomeLab.git
cd HomeLab

# Run directly from repo
./hl start

# Or install to ~/.homelab
./install.sh
```

## Upgrade

```bash
hl upgrade    # Download and install latest version
hl restart    # Restart services to apply
```

## Uninstall

```bash
hl uninstall  # Removes everything (LaunchAgent, ~/.homelab, symlink)
```

To also remove Docker containers and images:
```bash
cd ~/.homelab && docker compose down -v --rmi all
hl uninstall
```

## Services

| Service | Port | Description |
|---------|------|-------------|
| Open WebUI | 3000 | Chat interface |
| LM Studio | 1234 | LLM inference (MLX) |
| Watchtower | — | Auto-updates at 2 AM |

## Troubleshooting

```bash
hl doctor -v                  # Full system diagnostics
hl status                     # Check all services
hl logs -l ERROR              # View errors
```

**"Chunk too big" / streaming error** — Fast models can overwhelm the buffer. Increase it:
```bash
hl webui buffer-size 50
hl restart
```

**"lms: command not found"** — Open LM Studio app at least once to register the `lms` CLI command.

**Can't connect to LM Studio** — Copy URL from LM Studio menu bar (not `localhost`)

**LM Studio server won't start headless** — Enable "Local LLM Service" in LM Studio Settings → Developer

## Links

- [LM Studio](https://lmstudio.ai/) — Local LLM with MLX
- [Open WebUI](https://openwebui.com/) / [Docs](https://docs.openwebui.com/)
- [MLX](https://github.com/ml-explore/mlx) — Apple's ML framework

## License

MIT
