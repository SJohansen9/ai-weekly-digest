#!/bin/bash
# Publish the latest AI weekly digest Markdown file as a PDF on the Desktop.
set -euo pipefail

PROJECT_DIR="/Users/sarahjohansen/Projects/ai-weekly-digest"
OUTPUT_DIR="$PROJECT_DIR/output"
DESKTOP="$HOME/Desktop"
PYTHON="/usr/bin/python3"
CONVERTER="$PROJECT_DIR/scripts/markdown_to_pdf.py"

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
PDF_NAME="AI-Weekly-Digest-${BASENAME#digest-}.pdf"
PDF_PATH="$DESKTOP/$PDF_NAME"

"$PYTHON" "$CONVERTER" "$MD_FILE" "$PDF_PATH"

if [[ ! -s "$PDF_PATH" ]]; then
  echo "PDF generation failed: empty file at $PDF_PATH" >&2
  exit 1
fi

echo "Published: $PDF_PATH"
echo "Source:    $MD_FILE"
