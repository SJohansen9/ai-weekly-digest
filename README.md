# AI Weekly Digest

Weekly AI digest with impact assessment. Publishes a **Markdown file** to your Desktop.

## Quick test

```bash
~/Projects/ai-weekly-digest/scripts/publish-to-desktop.sh
```

Output: `~/Desktop/AI-Weekly-Digest-YYYY-MM-DD.md`

## One-time setup

### 1. GitHub repository
Create **`ai-weekly-digest`** on GitHub, then push:

```bash
cd ~/Projects/ai-weekly-digest
git remote add origin https://github.com/YOUR_USERNAME/ai-weekly-digest.git
git push -u origin main
```

### 2. Cursor Automation
In **Cursor → Automations → AI Weekly Digest**:

1. Set **Repository** to your `ai-weekly-digest` GitHub repo
2. Schedule: **Mondays 8:00 AM**
3. Prompt: agent writes `output/digest-YYYY-MM-DD.md` and **git push**es
4. Click **Save** and **Enable**

### 3. Local backup scheduler (recommended)
Copies the latest digest Markdown to your Desktop every **Monday 8:45 AM**:

```bash
~/Projects/ai-weekly-digest/scripts/install-schedule.sh
```

## Files

| File | Purpose |
|------|---------|
| `scripts/publish-to-desktop.sh` | Copy latest digest `.md` to Desktop |
| `templates/DIGEST_PROMPT.md` | Agent instructions |
| `output/digest-YYYY-MM-DD.md` | Weekly digest source files |

See `AUTOMATION.md` for why the cloud + local split is needed.
