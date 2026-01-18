#!/usr/bin/env bash
# HomeLab Logging Library
# Writes logs to SQLite database in ~/.homelab/logs/

HOMELAB_LIB_VERSION="1.0.0"

# HomeLab home directory (user installation)
HOMELAB_HOME="${HOMELAB_HOME:-$HOME/.homelab}"
LOG_DB_DIR="$HOMELAB_HOME/logs"
LOG_DB="$LOG_DB_DIR/homelab.db"

# Get project version from installed location or repo
homelab_version() {
  if [ -f "$HOMELAB_HOME/VERSION" ]; then
    cat "$HOMELAB_HOME/VERSION" | tr -d '\n'
  elif [ -f "${SCRIPT_DIR:-}/../../VERSION" ]; then
    cat "${SCRIPT_DIR:-}/../../VERSION" | tr -d '\n'
  else
    echo "$HOMELAB_LIB_VERSION"
  fi
}

# Initialize database if it doesn't exist
init_log_db() {
  mkdir -p "$LOG_DB_DIR"
  sqlite3 "$LOG_DB" <<EOF
CREATE TABLE IF NOT EXISTS logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  level TEXT NOT NULL,
  service TEXT NOT NULL,
  message TEXT NOT NULL,
  version TEXT
);
CREATE INDEX IF NOT EXISTS idx_logs_timestamp ON logs(timestamp);
CREATE INDEX IF NOT EXISTS idx_logs_service ON logs(service);
CREATE INDEX IF NOT EXISTS idx_logs_level ON logs(level);
EOF
}

# Migrate database schema if needed
migrate_log_db() {
  if [ -f "$LOG_DB" ]; then
    # Check if version column exists, add if not
    if ! sqlite3 "$LOG_DB" "PRAGMA table_info(logs);" | grep -q "version"; then
      sqlite3 "$LOG_DB" "ALTER TABLE logs ADD COLUMN version TEXT;"
    fi
  fi
}

# Log a message
# Usage: log_write "level" "service" "message"
log_write() {
  local level="$1"
  local service="$2"
  local message="$3"
  local version="$(homelab_version)"
  
  # Initialize DB if needed
  if [ ! -f "$LOG_DB" ]; then
    init_log_db
  else
    # Run migrations on existing DB
    migrate_log_db
  fi
  
  # Escape single quotes for SQL
  message="${message//\'/\'\'}"
  
  sqlite3 "$LOG_DB" "INSERT INTO logs (level, service, message, version) VALUES ('$level', '$service', '$message', '$version');"
}

# Convenience functions
log_info() {
  local service="$1"
  local message="$2"
  log_write "INFO" "$service" "$message"
  echo "✅ $message"
}

log_warn() {
  local service="$1"
  local message="$2"
  log_write "WARN" "$service" "$message"
  echo "⚠️  $message"
}

log_error() {
  local service="$1"
  local message="$2"
  log_write "ERROR" "$service" "$message"
  echo "❌ $message"
}

log_start() {
  local service="$1"
  local message="$2"
  log_write "INFO" "$service" "$message"
  echo "🚀 $message"
}

# Export version info
export HOMELAB_VERSION="$(homelab_version)"
export HOMELAB_LIB_VERSION
export HOMELAB_HOME
