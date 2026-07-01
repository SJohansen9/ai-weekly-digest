# Why the automation was failing

Cursor Automations run as **cloud agents** on your **GitHub repo**. They do not run on your Mac.

## Root causes

| # | Problem | Why it breaks |
|---|---------|---------------|
| 1 | **No GitHub remote** | Cloud agent has nothing to clone if the repo is only on your Mac. |
| 2 | **Desktop step in cloud** | Cloud agents cannot write to `~/Desktop` directly. |
| 3 | **Automation not enabled** | Draft must be saved with repo selected and enabled. |
| 4 | **Local scheduler missing** | Nothing on your Mac copies the file to Desktop after push. |

## Correct architecture

```
MONDAY 8:00 AM — Cursor Automation (cloud)
  → Research AI news
  → Write output/digest-YYYY-MM-DD.md
  → git commit + git push

MONDAY 8:45 AM — Local macOS scheduler (your Mac)
  → git pull
  → publish-to-desktop.sh
  → Markdown file on ~/Desktop/AI-Weekly-Digest-YYYY-MM-DD.md
```

## Fix checklist

### 1. Push to GitHub
```bash
cd ~/Projects/ai-weekly-digest
git remote add origin https://github.com/YOUR_USERNAME/ai-weekly-digest.git
git push -u origin main
```

### 2. Enable Cursor Automation
- Repository → your `ai-weekly-digest` repo
- Agent writes Markdown and **git push** only
- Save and Enable

### 3. Install local scheduler
```bash
~/Projects/ai-weekly-digest/scripts/install-schedule.sh
```

Or manually:
```bash
cp ~/Projects/ai-weekly-digest/scripts/com.sarahjohansen.ai-weekly-digest.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.sarahjohansen.ai-weekly-digest.plist
```

### 4. Test
```bash
~/Projects/ai-weekly-digest/scripts/publish-to-desktop.sh
```

Output: `~/Desktop/AI-Weekly-Digest-YYYY-MM-DD.md`
