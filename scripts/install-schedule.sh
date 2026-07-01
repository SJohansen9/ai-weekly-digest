#!/bin/bash
set -euo pipefail

PLIST_SRC="$(cd "$(dirname "$0")/.." && pwd)/scripts/com.sarahjohansen.ai-weekly-digest.plist"
PLIST_DST="$HOME/Library/LaunchAgents/com.sarahjohansen.ai-weekly-digest.plist"

mkdir -p "$HOME/Library/LaunchAgents"
cp "$PLIST_SRC" "$PLIST_DST"

UID_NUM=$(id -u)
launchctl bootout "gui/${UID_NUM}/com.sarahjohansen.ai-weekly-digest" 2>/dev/null || true
launchctl bootstrap "gui/${UID_NUM}" "$PLIST_DST" 2>/dev/null || launchctl load "$PLIST_DST"

echo "Installed: Mondays 8:45 AM -> copy digest Markdown to Desktop"
