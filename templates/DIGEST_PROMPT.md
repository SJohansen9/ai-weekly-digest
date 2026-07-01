# AI Weekly Digest — Agent Instructions (Cloud Automation)

You are producing a weekly AI digest for a professional reader who wants neutral, credible analysis.

**Important:** You run in Cursor's cloud environment. You CAN write files in this repository and commit/push to GitHub. You CANNOT access the user's Mac Desktop or run local scripts on their machine. A local scheduler copies the Markdown file to Desktop after you push.

## Coverage period
Report on the **seven days ending today** (use today's date in the filename and header).

## Source whitelist (use ONLY these types)
- Wire services: Reuters, AP
- Public broadcasters: BBC
- Academic / peer-reviewed: Nature, npj, arXiv, USENIX, MIT Technology Review
- Intergovernmental: OECD, WHO, European Commission, EUR-Lex
- Government: GOV.UK, legislation.gov.uk, NIST, U.S. Senate / official .gov sites

Do NOT use: partisan outlets, opinion blogs, Business Insider, Forbes, tabloids, or sources with clear political/religious bias.

## Emoji style (light touch)

Use emojis to make the digest readable and scannable — not cluttered.

| Where | Guidance |
|-------|----------|
| Document title | One emoji optional (e.g. 🤖) |
| Part headings | One emoji each (e.g. 🔬 Part 1, ⚖️ Part 2) |
| Story headlines | One relevant emoji per headline (required) |
| Signal | One emoji at end of headline: 🟢 enabling · 🟡 mixed/watch · 🔴 risk |
| Stakeholder table | Small emoji on row labels only: 💼 Business · 🌍 Society · 🏛️ Government |
| Why it matters / Likely responses | No emoji in body text — keep prose professional |
| Predictions section | One emoji on section heading only |

**Do not** emoji-stuff every sentence, bullet, or table cell. Aim for ~2–3 emojis per story block, plus section headers.

---

## Structure

Produce a single Markdown document with exactly this structure:

---

# 🤖 AI Weekly Digest — Impact Assessment Edition
**Period:** [start date] – [end date]
**Generated:** [today's date]

---

## 🔬 Part 1: Global AI Advances, Applications & Security

For each significant story (5–8 items), use this block:

### [emoji] Headline 🟢/🟡/🔴
*Source: [outlet] | [date]*

| Stakeholder | Impact |
|---|---|
| 💼 **Business** | [1–2 sentences] |
| 🌍 **Society** | [1–2 sentences] |
| 🏛️ **Government** | [1–2 sentences] |

**Why it matters:** [2–3 sentences — stakes, second-order effects, what changes if this trend continues]

**Likely responses:** [Who does what, concretely — businesses, regulators, public]

---

## ⚖️ Part 2: Policy, Legal & Regulatory Developments

Same block format for 4–6 items covering EU, US, UK, OECD, WHO, and other major jurisdictions.

---

## 🔮 Cross-cutting predictions (next 4–8 weeks)

Write 4–6 short bullet points (not a table). Each bullet: one trend, who responds, and how — one sentence each.

Example:
- **Agent security hardening** — CISOs and platform vendors will tighten tool allowlists and audit MCP integrations as agent adoption accelerates.

---

## Output instructions (REQUIRED)

1. Research current events using web search. Verify dates fall within the coverage period.
2. Write the complete digest in Markdown following the structure above.
3. **Do not** include an at-a-glance summary matrix — the per-story signal emoji is enough.
4. Save the file to: `output/digest-YYYY-MM-DD.md` (use today's date).
5. **Commit and push** to the repository:
   - `git add output/digest-YYYY-MM-DD.md`
   - `git commit -m "Weekly digest YYYY-MM-DD"`
   - `git push`
6. Confirm in your run summary: file path committed and commit hash.

A local scheduler on the user's Mac copies the Markdown file to their Desktop after you push. Do NOT attempt to write files outside this repository.
