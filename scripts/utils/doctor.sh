#!/usr/bin/env bash
# HomeLab Doctor - Check system requirements
# Usage: doctor.sh [--verbose|-v]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

VERBOSE=false
ISSUES=0

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --verbose|-v)
      VERBOSE=true
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# Logging helpers
log_ok() {
  if $VERBOSE; then
    echo "✅ $1"
  fi
}

log_warn_msg() {
  if $VERBOSE; then
    echo "⚠️  $1"
  fi
}

log_error_msg() {
  echo "❌ $1"
}

log_info_msg() {
  if $VERBOSE; then
    echo "   $1"
  fi
}

log_section() {
  if $VERBOSE; then
    echo ""
    echo "$1"
  fi
}

# Header
if $VERBOSE; then
  echo ""
  echo "🩺 HomeLab Doctor"
  echo "================="
fi

# Check macOS
log_section "Checking operating system..."
if [[ "$(uname)" == "Darwin" ]]; then
  OS_VERSION=$(sw_vers -productVersion)
  CHIP=$(uname -m)
  log_ok "macOS $OS_VERSION ($CHIP)"
  
  if [[ "$CHIP" == "arm64" ]]; then
    log_info_msg "Apple Silicon detected - optimal for MLX"
  else
    log_warn_msg "Intel Mac - MLX acceleration not available"
  fi
else
  log_error_msg "Not macOS - HomeLab is designed for macOS only"
  ((ISSUES++))
fi

# Check Docker Desktop
log_section "Checking Docker Desktop..."
if command -v docker >/dev/null 2>&1; then
  DOCKER_VERSION=$(docker --version 2>/dev/null | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1)
  log_ok "Docker installed (v$DOCKER_VERSION)"
  
  # Check if Docker Desktop is running
  if docker info >/dev/null 2>&1; then
    log_ok "Docker Desktop is running"
  else
    log_warn_msg "Docker Desktop is not running"
    log_info_msg "Run: hl start (or open Docker Desktop manually)"
  fi
else
  log_error_msg "Docker Desktop not installed"
  echo ""
  echo "   Install Docker Desktop:"
  echo "   https://www.docker.com/products/docker-desktop/"
  echo ""
  ((ISSUES++))
fi

# Check LM Studio (REQUIRED)
log_section "Checking LM Studio..."
if command -v lms >/dev/null 2>&1; then
  log_ok "LM Studio CLI installed"
  
  # Check if server is running (only in verbose mode)
  if $VERBOSE; then
    if lms status 2>&1 | grep -q "Server: ON"; then
      log_ok "LM Studio server is running"
    else
      log_warn_msg "LM Studio server is not running"
      log_info_msg "Run: hl start (or start from LM Studio app)"
    fi
    
    # Check for loaded models
    if lms status 2>&1 | grep -q "Loaded Models"; then
      log_ok "Model loaded"
    else
      log_warn_msg "No model loaded"
      log_info_msg "Open LM Studio and load a model"
    fi
  fi
else
  log_error_msg "LM Studio CLI not found"
  echo ""
  echo "   LM Studio must be installed and CLI enabled."
  echo ""
  echo "   1. Install LM Studio:"
  echo "      https://lmstudio.ai/"
  echo ""
  echo "   2. Open LM Studio at least once to register the CLI"
  echo ""
  echo "   3. Enable CLI:"
  echo "      LM Studio → Settings → Developer → Enable CLI"
  echo ""
  echo "   4. Enable headless mode (required for auto-start):"
  echo "      LM Studio → Settings → Developer → Enable Local LLM Service"
  echo ""
  ((ISSUES++))
fi

# Check sqlite3 (for logs)
log_section "Checking sqlite3..."
if command -v sqlite3 >/dev/null 2>&1; then
  log_ok "sqlite3 installed"
else
  log_error_msg "sqlite3 not installed"
  echo "   Required for logging. Install via Homebrew:"
  echo "   brew install sqlite3"
  ((ISSUES++))
fi

# Check configuration (only in verbose mode)
if $VERBOSE; then
  log_section "Checking configuration..."
  if [ -f "$HOMELAB_HOME/.env" ]; then
    log_ok "Configuration file exists"
    
    # Check if secret key is set
    if grep -q "your-secret-key-here" "$HOMELAB_HOME/.env" 2>/dev/null; then
      log_warn_msg "WEBUI_SECRET_KEY not configured"
      log_info_msg "Generate one: openssl rand -hex 32"
    else
      log_ok "WEBUI_SECRET_KEY configured"
    fi
  else
    log_warn_msg "No .env file found"
    log_info_msg "Run: cp $HOMELAB_HOME/.env.example $HOMELAB_HOME/.env"
  fi
fi

# Summary
if $VERBOSE; then
  echo ""
  echo "================="
  
  if [ $ISSUES -eq 0 ]; then
    echo "✅ All checks passed!"
    echo ""
    echo "Run 'hl start' to start all services."
  else
    echo "❌ $ISSUES issue(s) found"
    echo ""
    echo "Please fix the issues above before running HomeLab."
  fi
  echo ""
fi

# Exit with error if issues found
if [ $ISSUES -gt 0 ]; then
  if ! $VERBOSE; then
    echo ""
    echo "Run 'hl doctor -v' for detailed diagnostics."
  fi
  exit 1
fi

exit 0
