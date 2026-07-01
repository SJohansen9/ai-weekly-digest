#!/bin/bash
# Local weekly job: pull latest digest from GitHub, publish PDF to Desktop.
set -euo pipefail

PROJECT_DIR="/Users/sarahjohansen/Projects/ai-weekly-digest"
LOG="$PROJECT_DIR/output/local-scheduler.log"
PYTHON="/usr/bin/python3"

exec >>"$LOG" 2>&1
echo "=== $(date) ==="

cd "$PROJECT_DIR"

# Ensure Python deps
if ! "$PYTHON" -c "import fpdf" 2>/dev/null; then
  "$PYTHON" -m pip install --user -r "$PROJECT_DIR/requirements.txt"
fi

# Pull latest digest from GitHub (if remote configured)
if git remote get-url origin >/dev/null 2>&1; then
  git pull --rebase --autostash origin main || git pull --rebase --autostash || true
else
  echo "WARNING: No git remote configured. Using local output/ only."
fi

"$PROJECT_DIR/scripts/publish-to-desktop.sh"
echo "Done."
