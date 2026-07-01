#!/usr/bin/env python3
"""Convert AI weekly digest Markdown to a styled PDF using fpdf2."""

from __future__ import annotations

import html
import re
import sys
from pathlib import Path

import fpdf
from fpdf import FPDF

FONT_DIR = Path(fpdf.__file__).parent / "font"
UNICODE_FONT = Path("/System/Library/Fonts/Supplemental/Arial Unicode.ttf")
if not UNICODE_FONT.is_file():
    UNICODE_FONT = Path("/Library/Fonts/Arial Unicode.ttf")

CSS = """
body { font-family: Helvetica; font-size: 10pt; color: #1a1a1a; line-height: 1.5; }
h1 { font-size: 20pt; color: #0f172a; border-bottom: 2px solid #2563eb; padding-bottom: 6px; margin-bottom: 8px; }
.meta { font-size: 9pt; color: #475569; margin-bottom: 16px; }
h2 { font-size: 14pt; color: #1e40af; border-bottom: 1px solid #cbd5e1; padding-bottom: 4px; margin-top: 18px; margin-bottom: 10px; }
.story { border: 1px solid #dbeafe; border-left: 4px solid #2563eb; background: #f8fafc; padding: 10px 12px; margin-bottom: 14px; }
h3 { font-size: 11pt; color: #0f172a; margin: 0 0 4px 0; }
.source { font-size: 8.5pt; color: #64748b; font-style: italic; margin-bottom: 8px; }
table { width: 100%; border-collapse: collapse; margin: 8px 0; font-size: 9pt; }
th { background: #1e3a8a; color: #ffffff; text-align: left; padding: 6px 8px; }
td { border: 1px solid #e2e8f0; padding: 6px 8px; vertical-align: top; }
.label { margin-top: 8px; font-size: 9.5pt; }
.label b { color: #1e40af; }
.legend { font-size: 9pt; color: #64748b; }
.signal-green { color: #15803d; font-weight: bold; text-align: center; }
.signal-amber { color: #b45309; font-weight: bold; text-align: center; }
.signal-red { color: #b91c1c; font-weight: bold; text-align: center; }
hr { border: none; border-top: 1px dashed #cbd5e1; margin: 12px 0; }
"""


def normalize_unicode(text: str) -> str:
    text = re.sub(r"[\U0001F300-\U0001FAFF\U00002600-\U000027BF\U0000FE0F]", "", text)
    return (
        text.replace("\u2014", " - ")
        .replace("\u2013", "-")
        .replace("\u2018", "'")
        .replace("\u2019", "'")
        .replace("\u201c", '"')
        .replace("\u201d", '"')
    )


def inline_md(text: str) -> str:
    text = normalize_unicode(text)
    text = html.escape(text)
    text = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", text)
    text = re.sub(r"\*(.+?)\*", r"<i>\1</i>", text)
    return text


def signal_class(cell: str) -> str:
    cell = normalize_unicode(cell)
    if "Green" in cell or cell.strip().upper() == "G":
        return "signal-green"
    if "Red" in cell or cell.strip().upper() == "R":
        return "signal-red"
    return "signal-amber"


def markdown_to_html(md: str) -> str:
    lines = [line.rstrip() for line in md.splitlines()]
    parts: list[str] = []
    in_table = False
    in_story = False
    meta_bits: list[str] = []

    def close_table() -> None:
        nonlocal in_table
        if in_table:
            parts.append("</tbody></table>")
            in_table = False

    def close_story() -> None:
        nonlocal in_story
        if in_story:
            close_table()
            parts.append("</div>")
            in_story = False

    for line in lines:
        if in_table and not line.startswith("|"):
            close_table()

        if line.startswith("---"):
            close_story()
            parts.append("<hr/>")
        elif m := re.match(r"^# (.+)$", line):
            close_story()
            parts.append(f"<h1>{inline_md(m.group(1))}</h1>")
        elif m := re.match(r"^## (.+)$", line):
            close_story()
            parts.append(f"<h2>{inline_md(m.group(1))}</h2>")
        elif m := re.match(r"^### (.+)$", line):
            close_story()
            parts.append('<div class="story">')
            parts.append(f"<h3>{inline_md(m.group(1))}</h3>")
            in_story = True
        elif m := re.match(r"^\*(.+)\*$", line):
            parts.append(f'<p class="source">{inline_md(m.group(1))}</p>')
        elif line.startswith("|"):
            if "---" in line:
                continue
            cells = [c.strip() for c in line.strip("|").split("|")]
            if not in_table:
                parts.append("<table><thead><tr>")
                for cell in cells:
                    parts.append(f"<th>{inline_md(cell)}</th>")
                parts.append("</tr></thead><tbody>")
                in_table = True
            else:
                cls = signal_class(cells[-1]) if cells else ""
                parts.append("<tr>")
                for i, cell in enumerate(cells):
                    if i == len(cells) - 1 and cls:
                        parts.append(f'<td class="{cls}">{inline_md(cell)}</td>')
                    else:
                        parts.append(f"<td>{inline_md(cell)}</td>")
                parts.append("</tr>")
        elif m := re.match(r"^\*\*(Period|Generated)\*\*\s*:?\s*(.*)$", line):
            meta_bits.append(
                f"<b>{html.escape(m.group(1))}:</b> {inline_md(m.group(2).lstrip(': '))}"
            )
        elif m := re.match(r"^\*\*(Legend)\*\*\s*:?\s*(.*)$", line):
            parts.append(f'<p class="legend">{inline_md(m.group(2).lstrip(": "))}</p>')
        elif m := re.match(r"^\*\*(.+?)\*\*\s*(.+)$", line):
            label = html.escape(m.group(1))
            rest = inline_md(m.group(2).lstrip(": "))
            parts.append(f'<p class="label"><b>{label}:</b> {rest}</p>')
        elif not line.strip():
            continue
        else:
            parts.append(f"<p>{inline_md(line)}</p>")

    close_story()

    body = "\n".join(parts)
    if meta_bits:
        meta = '<p class="meta">' + " | ".join(meta_bits) + "</p>"
        body = re.sub(r"(</h1>)", r"\1\n" + meta, body, count=1)

    return f"<style>{CSS}</style>\n{body}"


def convert(md_path: Path, pdf_path: Path) -> None:
    md = md_path.read_text(encoding="utf-8")
    html_doc = markdown_to_html(md)

    pdf = FPDF(format="A4")
    pdf.set_auto_page_break(auto=True, margin=15)
    if not UNICODE_FONT.is_file():
        raise FileNotFoundError(f"Unicode font not found: {UNICODE_FONT}")
    pdf.add_font("Body", "", str(UNICODE_FONT))
    pdf.add_font("Body", "B", str(UNICODE_FONT))
    pdf.add_font("Body", "I", str(UNICODE_FONT))
    pdf.add_font("Body", "BI", str(UNICODE_FONT))
    pdf.set_font("Body", size=10)
    pdf.add_page()
    pdf.write_html(html_doc)
    pdf_path.parent.mkdir(parents=True, exist_ok=True)
    pdf.output(str(pdf_path))


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: markdown_to_pdf.py <input.md> <output.pdf>", file=sys.stderr)
        return 1

    md_path = Path(sys.argv[1])
    pdf_path = Path(sys.argv[2])

    if not md_path.is_file():
        print(f"Input not found: {md_path}", file=sys.stderr)
        return 1

    convert(md_path, pdf_path)
    size_kb = pdf_path.stat().st_size / 1024
    print(pdf_path)
    print(f"PDF size: {size_kb:.1f} KB")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
