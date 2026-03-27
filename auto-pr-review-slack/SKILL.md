---
name: auto-pr-review-slack
description: Automated PR review workflow triggered by Slack messages. Monitors Slack channels for PR review requests, extracts PR URLs, verifies review status, and delegates to code-review skill. Use when running scheduled PR review checks (cron) or manual PR review sweeps from Slack activity.
license: MIT
compatibility: Requires Slack API token, gh CLI, cursor-agent, and code-review skill
metadata:
  author: roy-songzhe-li
  version: "1.0.0"
  created: "2026-03-27"
  status: ready
---

# Auto PR Review (Slack-Triggered)

Automated PR review workflow that monitors Slack channels for PR review requests and delegates to the code-review skill.

## Overview

This skill orchestrates the entire PR review automation:

1. **Check eligibility** (weekday, not holiday)
2. **Read Slack messages** from configured channel
3. **Extract PR URLs** from team messages
4. **Verify PR status** (not already reviewed)
5. **Delegate to code-review skill** via cursor-agent
6. **Report results** to Discord

## Prerequisites

### Required Tools
- `gh` CLI (authenticated)
- `curl` (for Slack API)
- `jq` (for JSON parsing)
- `cursor-agent` (for code review execution)

### Required Configuration
- Slack token: `~/.openclaw/secrets/slack-token`
- Code-review skill: `~/Desktop/CognitiveCreators/Agent Skills/code-review/`
- Cursor CLI config: `~/.cursor/cli-config.json` (with permissions)

### Environment Variables
```bash
SLACK_TOKEN=$(cat ~/.openclaw/secrets/slack-token)
SLACK_CHANNEL="C08U6JPHD40"  # aetheron-connect-devs
REVIEWER="roy-songzhe-li"
ROY_USER_ID="U08MNQZGHBP"
REPO="aetheronhq/aetheron-connect-v2"
```

## Usage

### Step 1: Check Eligibility

Before running, verify:

**A. Not a weekend:**
```bash
DAY_OF_WEEK=$(date +%u)  # 1=Monday, 7=Sunday
if [ "$DAY_OF_WEEK" -eq 6 ] || [ "$DAY_OF_WEEK" -eq 7 ]; then
    echo "⏭️  Skipped: Weekend"
    exit 0
fi
```

**B. Not a SA public holiday (2026):**
```bash
MONTH=$(date +%m)
DAY=$(date +%d)
DATE_CHECK="$MONTH-$DAY"

# Check against holiday list
# 01-01, 01-26, 03-09, 04-18, 04-19, 04-20, 04-21, 04-25,
# 06-08, 09-28, 12-24, 12-25, 12-26, 12-31
```

**Holiday list (South Australia 2026):**
- 01-01: New Year's Day
- 01-26: Australia Day
- 03-09: Adelaide Cup Day
- 04-18: Good Friday
- 04-19: Easter Saturday
- 04-20: Easter Sunday
- 04-21: Easter Monday
- 04-25: Anzac Day
- 06-08: Queen's Birthday
- 09-28: Adelaide Show Day
- 12-24: Christmas Eve
- 12-25: Christmas Day
- 12-26: Proclamation Day
- 12-31: New Year's Eve

### Step 2: Determine Time Range

Calculate Slack message time range based on current time:

**11:00 AM run:**
```bash
# Read from yesterday 6:30 PM to now
YESTERDAY=$(date -v-1d +%Y-%m-%d)
START_TIME=$(date -j -f "%Y-%m-%d %H:%M:%S" "$YESTERDAY 18:30:00" +%s)
```

**3:30 PM run:**
```bash
# Read from today 11:00 AM to now
TODAY=$(date +%Y-%m-%d)
START_TIME=$(date -j -f "%Y-%m-%d %H:%M:%S" "$TODAY 11:00:00" +%s)
```

**6:30 PM run:**
```bash
# Read from today 3:30 PM to now
TODAY=$(date +%Y-%m-%d)
START_TIME=$(date -j -f "%Y-%m-%d %H:%M:%S" "$TODAY 15:30:00" +%s)
```

**Manual run (fallback):**
```bash
# Read from last 24 hours
START_TIME=$(date -v-24H +%s)
```

### Step 3: Read Slack Messages

Fetch messages from configured channel:

```bash
SLACK_TOKEN=$(cat ~/.openclaw/secrets/slack-token)
SLACK_CHANNEL="C08U6JPHD40"
ROY_USER_ID="U08MNQZGHBP"

messages=$(curl -s -H "Authorization: Bearer $SLACK_TOKEN" \
    "https://slack.com/api/conversations.history?channel=$SLACK_CHANNEL&oldest=$START_TIME&limit=100")

# Check API response
if ! echo "$messages" | jq -e '.ok' >/dev/null; then
    echo "❌ Slack API error"
    exit 1
fi
```

### Step 4: Extract PR URLs

Filter messages and extract GitHub PR links:

```bash
# Save messages and extract text (exclude Roy's messages)
echo "$messages" > /tmp/slack-messages.json
echo "$messages" | jq -r ".messages[] | select(.user != \"$ROY_USER_ID\") | .text" > /tmp/all-messages.txt

# Extract GitHub PR URLs (only target repo)
REPO="aetheronhq/aetheron-connect-v2"
pr_urls=$(grep -Eo "https://github.com/$REPO/pull/[0-9]+" /tmp/all-messages.txt | sort -u)

if [ -z "$pr_urls" ]; then
    echo "✅ No PR review requests found"
    exit 0
fi
```

### Step 5: Verify PR Status

For each PR, check if review is needed:

```bash
cd ~/Desktop/CognitiveCreators/repos/aetheron-connect-v2

for pr_url in $pr_urls; do
    pr_num=$(echo "$pr_url" | grep -Eo '[0-9]+$')
    
    # Get PR info
    pr_info=$(gh pr view "$pr_num" --repo "$REPO" --json author,reviewRequests,reviews,state)
    
    # Skip if PR is not open
    state=$(echo "$pr_info" | jq -r '.state')
    if [ "$state" != "OPEN" ]; then
        echo "⏭️  Skip PR #$pr_num (already $state)"
        continue
    fi
    
    # Skip if author is Roy
    author=$(echo "$pr_info" | jq -r '.author.login')
    if [ "$author" = "$REVIEWER" ]; then
        echo "⏭️  Skip PR #$pr_num (authored by Roy)"
        continue
    fi
    
    # Check if Roy already reviewed and not re-requested
    roy_review=$(echo "$pr_info" | jq -r ".reviews[]? | select(.author.login == \"$REVIEWER\") | .state")
    requested=$(echo "$pr_info" | jq -r ".reviewRequests[]?.login | select(. == \"$REVIEWER\")")
    
    if [ -n "$roy_review" ] && [ -z "$requested" ]; then
        echo "⏭️  Skip PR #$pr_num (already reviewed, not re-requested)"
        continue
    fi
    
    # This PR needs review
    echo "✅ PR #$pr_num needs review"
done
```

### Step 6: Delegate to Code-Review Skill

For each PR needing review, use cursor-agent:

```bash
AGENT_SKILLS_DIR="/Users/roy-songzhe-li/Desktop/CognitiveCreators/Agent Skills/code-review"

cursor-agent --model claude-4.6-opus-max --print --force -p "Use the code-review Agent Skill to review PR #$pr_num.

**Skill location:** $AGENT_SKILLS_DIR

**Task:**
1. Read the SKILL.md for review guidelines
2. Fetch PR #$pr_num from $REPO
3. Read project AGENTS.md for architecture rules (if exists)
4. Review following skill guidelines:
   - FIRST: Analyze Behavioral Impact (mandatory)
   - THEN: Check code correctness
   - Use tentative language
   - One sentence per comment
5. Generate concise review
6. Post review to GitHub using gh CLI

Repository: $REPO
PR number: $pr_num

Start by reading the SKILL.md." --mode=ask --output-format text
```

**Important flags:**
- `--print` - Script mode (non-interactive)
- `--force` - Bypass permission prompts
- `--mode=ask` - Q&A style (read-only planning, no edits)
- `--output-format text` - Plain text output

### Step 7: Report Results

After all PRs are processed:

```bash
echo "🎉 All PR reviews completed!"
```

## Complete Script

The full automation script is available at:
`~/.openclaw/skills/auto-pr-review.sh`

Run it manually:
```bash
bash ~/.openclaw/skills/auto-pr-review.sh
```

## Scheduled Execution

### Cron Jobs

Three daily runs (weekdays only):

**Morning (11:00 AM):**
```json
{
  "name": "PR Review (Morning 11:00 AM)",
  "schedule": { "expr": "0 11 * * 1-5", "tz": "Australia/Adelaide" },
  "payload": {
    "kind": "agentTurn",
    "message": "Run the auto PR review script: bash ~/.openclaw/skills/auto-pr-review.sh"
  },
  "delivery": {
    "channel": "discord",
    "to": "channel:1486947748858040320"
  }
}
```

**Afternoon (3:30 PM):**
```json
{
  "name": "PR Review (Afternoon 3:30 PM)",
  "schedule": { "expr": "30 15 * * 1-5", "tz": "Australia/Adelaide" },
  "payload": {
    "kind": "agentTurn",
    "message": "Run the auto PR review script: bash ~/.openclaw/skills/auto-pr-review.sh"
  }
}
```

**Evening (6:30 PM):**
```json
{
  "name": "PR Review (Evening 6:30 PM)",
  "schedule": { "expr": "30 18 * * 1-5", "tz": "Australia/Adelaide" },
  "payload": {
    "kind": "agentTurn",
    "message": "Run the auto PR review script: bash ~/.openclaw/skills/auto-pr-review.sh"
  }
}
```

### Add Cron Jobs

```bash
openclaw cron add \
  --name "PR Review (Morning)" \
  --schedule "0 11 * * 1-5" \
  --tz "Australia/Adelaide" \
  --payload '{
    "kind": "agentTurn",
    "message": "Run the auto PR review script: bash ~/.openclaw/skills/auto-pr-review.sh",
    "channel": "discord",
    "target": "channel:1486947748858040320"
  }'
```

## Integration with Code-Review Skill

This skill **orchestrates** the workflow but **delegates** actual code review to the `code-review` skill:

**Division of responsibility:**

| This Skill (auto-pr-review-slack) | Code-Review Skill |
|-----------------------------------|-------------------|
| Check eligibility (weekday/holiday) | Verify PR identity |
| Read Slack messages | Fetch PR diff |
| Extract PR URLs | Read AGENTS.md |
| Filter by review status | Analyze code quality |
| Verify PR state (open/closed) | Assess behavioral impact |
| Call cursor-agent | Generate review comments |
| Report results | Post to GitHub |

**Why separate?**

1. **Reusability** - `code-review` can be used standalone
2. **Maintainability** - Changes to review logic don't affect Slack integration
3. **Testability** - Test PR review without Slack dependency
4. **Flexibility** - Add other triggers (email, webhooks) later

## Behavioral Impact Analysis

This workflow enforces the **Behavioral Impact** principle introduced in code-review v2.0:

**Before reviewing code correctness, ask:**
1. "What changes for the end user?"
2. "What are the downstream effects?"
3. "Is this a behavior change disguised as a refactor?"

The cursor-agent will apply these checks automatically via the code-review skill.

## Troubleshooting

### Slack API Errors

**401 Unauthorized:**
```bash
# Verify token
curl -H "Authorization: Bearer $(cat ~/.openclaw/secrets/slack-token)" \
  https://slack.com/api/auth.test
```

**No messages found:**
- Check `$START_TIME` calculation
- Verify Slack channel ID
- Confirm messages exist in time range

### Cursor-Agent Permission Denied

**Solution 1: Check config file**
```bash
cat ~/.cursor/cli-config.json
```

**Solution 2: Use --force flag**
```bash
cursor-agent --print --force -p "..."
```

### PR Already Merged

The script now checks PR state before reviewing:
```bash
state=$(echo "$pr_info" | jq -r '.state')
if [ "$state" != "OPEN" ]; then
    echo "⏭️  Skip (already $state)"
fi
```

## References

- **Code-Review Skill:** `~/Desktop/CognitiveCreators/Agent Skills/code-review/SKILL.md`
- **Script Location:** `~/.openclaw/skills/auto-pr-review.sh`
- **Cursor Config:** `~/.cursor/cli-config.json`
- **Slack API Docs:** https://api.slack.com/methods

## Example Output

```
🔍 Checking Slack messages (today 11:00 AM to now)...
   From: 2026-03-27 11:00:00
📋 Found PR review requests:
https://github.com/aetheronhq/aetheron-connect-v2/pull/699
https://github.com/aetheronhq/aetheron-connect-v2/pull/700

🔎 Checking PR #699...
✅ PR #699 needs review
🤖 Reviewing PR #699 with cursor-agent (claude-4.6-opus-max)...
✅ Review posted for PR #699

🔎 Checking PR #700...
⏭️  Skipping PR #700 (already reviewed, not re-requested)

🎉 All PR reviews completed!
```

## Tags

#automation #pr-review #slack #github #cursor-agent #code-review #cron #behavioral-impact

---

**Created:** 2026-03-27  
**Author:** Roy Li  
**Status:** Production Ready ✅
