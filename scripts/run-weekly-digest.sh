#!/bin/bash
# Local weekly job: pull latest digest from GitHub, copy Markdown to Desktop.
set -euo pipefail

PROJECT_DIR="/Users/sarahjohansen/Projects/ai-weekly-digest"
LOG="$PROJECT_DIR/output/local-scheduler.log"

exec >>"$LOG" 2>&1
echo "=== $(date) ==="

cd "$PROJECT_DIR"

if git remote get-url origin >/dev/null 2>&1; then
  git pull --rebase --autostash origin main || git pull --rebase --autostash || true
else
  echo "WARNING: No git remote configured. Using local output/ only."
fi

"$PROJECT_DIR/scripts/publish-to-desktop.sh"
echo "Done."
