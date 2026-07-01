# AI Weekly Digest — Agent Instructions

You are producing a weekly AI digest for a professional reader who wants neutral, credible analysis.

## Coverage period
Report on the **seven days ending today** (use today's date in the filename and header).

## Source whitelist (use ONLY these types)
- Wire services: Reuters, AP
- Public broadcasters: BBC
- Academic / peer-reviewed: Nature, npj, arXiv, USENIX, MIT Technology Review
- Intergovernmental: OECD, WHO, European Commission, EUR-Lex
- Government: GOV.UK, legislation.gov.uk, NIST, U.S. Senate / official .gov sites

Do NOT use: partisan outlets, opinion blogs, Business Insider, Forbes, tabloids, or sources with clear political/religious bias.

## Structure

Produce a single Markdown document with exactly this structure:

---

# AI Weekly Digest — Impact Assessment Edition
**Period:** [start date] – [end date]
**Generated:** [today's date]

---

## Part 1: Global AI Advances, Applications & Security

For each significant story (5–8 items), use this block:

### [emoji] Headline
*Source: [outlet] | [date]*

| Stakeholder | Impact |
|---|---|
| **Business** | [1–2 sentences] |
| **Society** | [1–2 sentences] |
| **Government** | [1–2 sentences] |

**Why it matters:** [2–3 sentences — stakes, second-order effects, what changes if this trend continues]

**Likely responses:** [Who does what, concretely — businesses, regulators, public]

---

## Part 2: Policy, Legal & Regulatory Developments

Same block format for 4–6 items covering EU, US, UK, OECD, WHO, and other major jurisdictions.

---

## At-a-glance matrix

| Headline | Why it matters (one line) | Signal |
|---|---|---|
| [emoji] [short title] | [one line] | 🟢 / 🟡 / 🔴 |

**Legend:** 🟢 Enabling · 🟡 Mixed / watch · 🔴 Risk / constraint

---

## Cross-cutting predictions (next 4–8 weeks)

| Trend | Who responds | How |
|---|---|---|

---

## Output instructions (REQUIRED)

1. Research current events using web search. Verify dates fall within the coverage period.
2. Write the complete digest in Markdown following the structure above.
3. Save the file to: `output/digest-YYYY-MM-DD.md` (use today's date).
4. Run this command to publish the PDF to the Desktop:
   ```
   /usr/bin/python3 /Users/sarahjohansen/Projects/ai-weekly-digest/scripts/markdown_to_pdf.py output/digest-YYYY-MM-DD.md ~/Desktop/AI-Weekly-Digest-YYYY-MM-DD.pdf
   ```
   Or use the wrapper:
   ```
   /Users/sarahjohansen/Projects/ai-weekly-digest/scripts/publish-to-desktop.sh
   ```
5. Confirm the PDF path: `~/Desktop/AI-Weekly-Digest-YYYY-MM-DD.pdf`

If the publish script fails, still save the Markdown file and report the error.
