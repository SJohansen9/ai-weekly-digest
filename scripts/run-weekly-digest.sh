#!/bin/bash
# Local weekly hook: pull latest digest from git (if configured) and publish PDF to Desktop.
set -euo pipefail

PROJECT_DIR="/Users/sarahjohansen/Projects/ai-weekly-digest"
cd "$PROJECT_DIR"

if command -v git >/dev/null 2>&1 && [[ -d .git ]]; then
  git pull --rebase --autostash 2>/dev/null || true
fi

exec "$PROJECT_DIR/scripts/publish-to-desktop.sh"
