#!/bin/bash
# Publish the latest AI weekly digest Markdown file to the Desktop.
set -euo pipefail

PROJECT_DIR="/Users/sarahjohansen/Projects/ai-weekly-digest"
OUTPUT_DIR="$PROJECT_DIR/output"
DESKTOP="$HOME/Desktop"

if [[ $# -ge 1 && -f "$1" ]]; then
  MD_FILE="$1"
else
  MD_FILE=$(ls -t "$OUTPUT_DIR"/digest-*.md 2>/dev/null | head -1)
fi

if [[ -z "${MD_FILE:-}" || ! -f "$MD_FILE" ]]; then
  echo "No digest markdown found in $OUTPUT_DIR" >&2
  exit 1
fi

BASENAME=$(basename "$MD_FILE" .md)
MD_NAME="AI-Weekly-Digest-${BASENAME#digest-}.md"
MD_PATH="$DESKTOP/$MD_NAME"

cp "$MD_FILE" "$MD_PATH"

if [[ ! -s "$MD_PATH" ]]; then
  echo "Publish failed: empty file at $MD_PATH" >&2
  exit 1
fi

echo "Published: $MD_PATH"
echo "Source:    $MD_FILE"
