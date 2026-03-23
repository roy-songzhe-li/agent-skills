---
name: slack-cli
description: Control Slack Desktop App via Chrome DevTools Protocol. Read messages, send messages, search history, and list channels as yourself (not a bot). Use when automating Slack interactions or monitoring messages.
license: MIT
compatibility: Requires Slack Desktop App, opencli, and CDP debugging enabled
metadata:
  author: roy-songzhe-li
  version: "1.0.0"
  created: "2026-03-23"
  status: development
---

# Slack CLI

Control Slack Desktop App via Chrome DevTools Protocol (CDP) to read and send messages as yourself.

## Quick Start

1. **Start Slack in debug mode:**
   ```bash
   bash assets/start-slack-debug.sh
   ```

2. **Set CDP endpoint:**
   ```bash
   export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9233"
   ```

3. **Verify connection:**
   ```bash
   opencli slack-app status
   ```

## Features

- ✅ Read channel/DM messages
- ✅ Send messages (as yourself, not a bot)
- ✅ Search message history
- ✅ List channels and members
- ✅ Check connection status

## Commands

| Command | Description | Example |
|---------|-------------|---------|
| `status` | Check CDP connection | `opencli slack-app status` |
| `read` | Read messages from current channel | `opencli slack-app read --count 20` |
| `send` | Send message to current channel | `opencli slack-app send "Hello"` |
| `channels` | List all channels with unread counts | `opencli slack-app channels` |
| `search` | Search messages | `opencli slack-app search "project"` |

## Use Cases

### Monitor Slack Messages

```bash
# Read latest 50 messages
opencli slack-app read --count 50

# Check for @mentions
opencli slack-app read --count 100 | grep "@roy"
```

### Auto-Reply

```bash
# AI analyzes and replies
opencli slack-app read --count 10
opencli slack-app send "Got it, I'll handle this"
```

### Search History

```bash
# Search project discussions
opencli slack-app search "sprint planning" --limit 20
```

### Channel Management

```bash
# List all channels with unread counts
opencli slack-app channels
```

## Integration with OpenClaw

### In Agent Skills

```javascript
// Read Slack messages
const messages = await exec('opencli slack-app read --count 20');

// Send reply
await exec('opencli slack-app send "AI assistant: Task recorded"');
```

### In Cron Jobs

```bash
opencli cron add \
  --name "Slack message check" \
  --schedule "0 */2 * * *" \
  --payload '{"kind":"agentTurn","message":"Check Slack and summarize"}'
```

## Architecture

```
Slack Desktop App (Electron)
    ↓
Chrome DevTools Protocol (CDP)
    ↓
http://127.0.0.1:9233
    ↓
OpenCLI Slack Adapter
    ↓
CLI commands
    ↓
OpenClaw Agent / Scripts
```

## Limitations

1. **Requires Slack restart** - CDP must be enabled at startup
2. **DOM selectors may change** - Slack updates may require selector adjustments
3. **Channel must be open** - Need to navigate to channel before sending
4. **Unofficial API** - Not officially supported by Slack, personal use only

## Setup

See [references/USAGE.md](references/USAGE.md) for detailed setup instructions.

Start script: [assets/start-slack-debug.sh](assets/start-slack-debug.sh)

## Status

- [x] Project structure
- [x] TypeScript implementation
- [x] Start script
- [x] Documentation
- [ ] DOM selector validation (needs testing)
- [ ] Error handling
- [ ] Unit tests
- [ ] ClawHub publication

## Resources

- [OpenCLI Project](https://github.com/jackwener/opencli)
- [Agent Skills Repo](https://github.com/roy-songzhe-li/agent-skills)
- [Usage Guide](references/USAGE.md)
- [Start Script](assets/start-slack-debug.sh)
