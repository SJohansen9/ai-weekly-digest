# Why the automation was failing

Cursor Automations run as **cloud agents**. They clone your **GitHub repo** and work there. They do **not** run on your Mac.

## Root causes

| # | Problem | Why it breaks |
|---|---------|---------------|
| 1 | **No GitHub remote** | Your project exists only on your Mac (`git remote` is empty). The cloud agent has nothing to clone. |
| 2 | **Desktop PDF step in cloud** | The prompt asked the agent to run `/Users/sarahjohansen/.../publish-to-desktop.sh` and write to `~/Desktop`. Cloud agents cannot access your Mac filesystem. |
| 3 | **Automation not fully enabled** | Opening the Automations editor pre-fills a draft — you must select the GitHub repo, Save, and Enable. |
| 4 | **Local backup never installed** | The macOS scheduler (`install-schedule.sh`) failed with a permission error, so nothing on your Mac publishes the PDF after the cloud run. |

## Correct architecture (two parts)

```
MONDAY 8:00 AM — Cursor Automation (cloud)
  → Research AI news
  → Write output/digest-YYYY-MM-DD.md
  → git commit + git push to GitHub

MONDAY 8:45 AM — Local macOS scheduler (your Mac)
  → git pull
  → publish-to-desktop.sh
  → PDF appears on ~/Desktop
```

## Fix checklist

### Step 1 — Push to GitHub
Create repo `ai-weekly-digest` at https://github.com/new then:

```bash
cd ~/Projects/ai-weekly-digest
git remote add origin https://github.com/YOUR_USERNAME/ai-weekly-digest.git
git push -u origin main
```

### Step 2 — Enable Cursor Automation
1. Cursor → **Automations**
2. Open **AI Weekly Digest** (or create new)
3. Set **Repository** → your `ai-weekly-digest` repo on GitHub
4. Schedule: **Mondays 8:00 AM**
5. **Save** and **Enable**

The prompt should only ask the agent to write Markdown and **git push** — not publish to Desktop.

### Step 3 — Install local PDF scheduler
Run in Terminal:

```bash
~/Projects/ai-weekly-digest/scripts/install-schedule.sh
```

If permission denied, run manually:

```bash
cp ~/Projects/ai-weekly-digest/scripts/com.sarahjohansen.ai-weekly-digest.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.sarahjohansen.ai-weekly-digest.plist
```

### Step 4 — Test locally
```bash
~/Projects/ai-weekly-digest/scripts/publish-to-desktop.sh
```

## Manual test of full flow

```bash
# Simulate what happens after cloud agent pushes:
cd ~/Projects/ai-weekly-digest
git pull
~/Projects/ai-weekly-digest/scripts/publish-to-desktop.sh
```
