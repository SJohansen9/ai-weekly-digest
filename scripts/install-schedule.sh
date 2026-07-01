#!/bin/bash
# Install the macOS LaunchAgent that publishes the latest digest PDF to Desktop every Monday.
set -euo pipefail

PLIST_SRC="$(cd "$(dirname "$0")/.." && pwd)/scripts/com.sarahjohansen.ai-weekly-digest.plist"
PLIST_DST="$HOME/Library/LaunchAgents/com.sarahjohansen.ai-weekly-digest.plist"

mkdir -p "$HOME/Library/LaunchAgents"
cp "$PLIST_SRC" "$PLIST_DST"

launchctl bootout "gui/$(id -u)/com.sarahjohansen.ai-weekly-digest" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST_DST"

echo "Installed weekly backup schedule: Mondays at 8:45 AM"
echo "Publishes latest digest from output/ to ~/Desktop/AI-Weekly-Digest-*.pdf"
