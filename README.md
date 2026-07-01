# AI Weekly Digest

Automated weekly AI digest with impact assessment. Publishes a **styled PDF** to your Desktop.

## Desktop output

```
~/Desktop/AI-Weekly-Digest-YYYY-MM-DD.pdf
```

## Manual publish (test anytime)

```bash
~/Projects/ai-weekly-digest/scripts/publish-to-desktop.sh
```

PDFs are generated via **Chrome headless** from styled HTML (tables, headings, colour-coded signals).

---

## Set up the Cursor Automation (one-time)

The **Automations editor** should be open with **AI Weekly Digest** pre-filled. Complete these steps:

### 1. Connect the GitHub repository
You connected GitHub — now link this project:

1. On [github.com/new](https://github.com/new), create a repo named **`ai-weekly-digest`** (private is fine).
2. In Cursor, open **Automations → AI Weekly Digest**.
3. Under **Repository**, select your new **`ai-weekly-digest`** repo.
4. Set branch to **`main`**.

### 2. Push this project to GitHub
Install **Xcode Command Line Tools** if prompted (`xcode-select --install`), then:

```bash
cd ~/Projects/ai-weekly-digest
git init
git add .
git commit -m "Initial AI weekly digest setup"
git remote add origin https://github.com/YOUR_USERNAME/ai-weekly-digest.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

### 3. Enable the automation
- **Schedule:** Every Monday at 8:00 AM
- **Prompt:** Already pre-filled (research → write digest → save Markdown → publish PDF)
- Click **Save** then **Enable**

### 4. Install the local PDF backup (recommended)
Cloud automations write to GitHub; this local job pulls the latest digest and ensures a PDF lands on your Desktop every Monday at 8:45 AM:

```bash
~/Projects/ai-weekly-digest/scripts/install-schedule.sh
```

---

## Project layout

```
ai-weekly-digest/
├── templates/DIGEST_PROMPT.md   # Agent instructions
├── output/digest-YYYY-MM-DD.md  # Weekly Markdown digests
├── scripts/
│   ├── markdown_to_pdf.rb       # Markdown → styled HTML → PDF (Chrome)
│   ├── publish-to-desktop.sh    # Publish latest digest to Desktop
│   └── install-schedule.sh      # Install macOS weekly backup scheduler
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| PDF looks plain/ugly | Re-run `publish-to-desktop.sh` — needs Google Chrome installed |
| Automation did not run | Check Automations → Runs; confirm repo is linked and enabled |
| No PDF on Desktop | Run `publish-to-desktop.sh` manually; check `output/digest-*.md` exists |
| Git commands fail | Install Xcode Command Line Tools |
