#!/usr/bin/env bash
# Show HomeLab version

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../lib/log.sh"

echo "HomeLab v$HOMELAB_VERSION"
echo "Library v$HOMELAB_LIB_VERSION"
