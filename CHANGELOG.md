# Changelog

All notable changes to HomeLab will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.2.0] - 2026-01-18

### Added

- **`hl upgrade`** — upgrade to latest version from GitHub
- **`hl uninstall`** — completely remove HomeLab (LaunchAgent, ~/.homelab, symlink)
- **`hl webui buffer-size [N]`** — set stream buffer size with unit support (MB/KB/B)
- **`hl webui list-env`** — view current WebUI configuration
- **LM Studio CLI path** — LaunchAgent now includes `~/.lmstudio/bin` in PATH
- **LM Studio app auto-open** — opens LM Studio if not running during startup

### Changed

- Renamed `hl install` → `hl auto-start` (clearer naming)
- Renamed `hl uninstall` (LaunchAgent) → `hl auto-start --off`
- Removed manual Configuration section from README (use CLI instead)
- Improved README "Before You Install" section
- Detailed Open WebUI → LM Studio connection instructions

### Fixed

- LaunchAgent PATH now includes `~/.lmstudio/bin` so `lms` command is found on login
- LM Studio startup waits up to 60s with retry loop
- Initial 10s delay for LaunchAgent to let login items start first

## [1.1.0] - 2026-01-18

### Added

- **CLI tool (`hl`)** — single command to manage all services
  - `hl start` / `hl stop` / `hl restart` — service lifecycle
  - `hl status` — check all services at a glance
  - `hl logs` — view, tail, filter, and clear logs
  - `hl doctor` — system requirements checker with verbose mode (`-v`)
  - `hl auto-start` — manage LaunchAgent for login auto-start
  - `hl ip` — show local IP for network access
  - `hl open` — open WebUI in browser
- **Installer (`install.sh`)** — one-command installation to `~/.homelab`
- **SQLite logging** — all service events logged to `~/.homelab/logs/homelab.db`
- **Sleep control flags**
  - `--allow-sleep` (`-as`) — start without caffeinate
  - `--allow-sleep-force` (`-asf`) — also kill running caffeinate
- **Doctor preflight checks** — validates macOS, Docker, LM Studio, sqlite3 before commands
- **Automatic releases** — GitHub Action creates release when VERSION changes
- **Versioning** — VERSION file tracks releases

### Changed

- LM Studio is now **required** (was optional) — doctor check fails without `lms` CLI
- LaunchAgent uses template with placeholders instead of hardcoded paths
- Reorganized scripts into `scripts/services/`, `scripts/utils/`, `scripts/lib/`
- Cursor commands reorganized into subfolders

### Fixed

- LaunchAgent now properly installs to user home directory
- Fixed missing `start.sh` in installer
- Fixed symlink resolution for CLI when installed via `/usr/local/bin`

## [1.0.0] - 2026-01-18

### Added

- Initial release
- `start.sh` — orchestrates caffeinate, LM Studio, Docker Desktop, and containers
- `docker-compose.yml` — Open WebUI + Watchtower (auto-updates)
- LaunchAgent for auto-start on login
- `.env` configuration with `WEBUI_SECRET_KEY` and chunk size settings
- Cursor IDE commands and rules

[Unreleased]: https://github.com/dmytro-afonin/HomeLab/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/dmytro-afonin/HomeLab/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/dmytro-afonin/HomeLab/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/dmytro-afonin/HomeLab/releases/tag/v1.0.0
