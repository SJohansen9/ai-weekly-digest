# AI Weekly Digest

Weekly AI digest with impact assessment. Publishes a styled PDF to your Desktop.

## Quick test

```bash
~/Projects/ai-weekly-digest/scripts/publish-to-desktop.sh
```

Output: `~/Desktop/AI-Weekly-Digest-YYYY-MM-DD.pdf`

## One-time setup

### 1. Python dependencies
```bash
python3 -m pip install --user -r ~/Projects/ai-weekly-digest/requirements.txt
```

### 2. GitHub repository
Create **`ai-weekly-digest`** on GitHub, then push:

```bash
cd ~/Projects/ai-weekly-digest
git remote add origin https://github.com/YOUR_USERNAME/ai-weekly-digest.git
git push -u origin main
```

### 3. Cursor Automation
The Automations editor should open with **AI Weekly Digest** pre-filled:

1. Set **Repository** to your `ai-weekly-digest` GitHub repo
2. Schedule: **Mondays 8:00 AM**
3. Click **Save** and **Enable**

### 4. Local backup scheduler (recommended)
Ensures PDF reaches Desktop even if the cloud agent only commits Markdown:

```bash
~/Projects/ai-weekly-digest/scripts/install-schedule.sh
```

Runs every **Monday 8:45 AM** — pulls latest from git and publishes PDF.

## Files

| File | Purpose |
|------|---------|
| `scripts/markdown_to_pdf.py` | Python PDF generator (fpdf2) |
| `scripts/publish-to-desktop.sh` | Publish latest digest to Desktop |
| `templates/DIGEST_PROMPT.md` | Agent instructions |
