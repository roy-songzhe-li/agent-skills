---
name: slack-web-helper
description: Access and reply to Slack messages via Slack Web using browser automation. Does not occupy Desktop App. Read messages, send replies, search history. Use when automating Slack without interfering with Desktop App usage.
license: MIT
compatibility: Requires OpenClaw browser tool with Slack Web access
metadata:
  author: roy-songzhe-li
  version: "1.0.0"
  created: "2026-03-23"
  status: ready
---

# Slack Web Helper

Access Slack via browser automation without occupying Desktop App.

## Features

- ✅ Read channel/DM messages via Slack Web
- ✅ Send messages (as yourself)
- ✅ Search message history
- ✅ Doesn't occupy Desktop App
- ✅ Runs in background

## Quick Example

```javascript
// Open Slack Web
await browser.open("https://app.slack.com/client/T123/C456");
await browser.act({ kind: "wait", timeMs: 3000 });

// Get page content
const snapshot = await browser.snapshot();

// Send a message
await browser.act({
  kind: "fill",
  selector: '[data-qa="message_input"]',
  text: "Hello from AI"
});

await browser.act({ kind: "press", key: "Enter" });
```

## Usage

### 1. Read Messages

```javascript
// Open channel
await browser.open("https://app.slack.com/client/WORKSPACE_ID/CHANNEL_ID");

// Wait for load
await browser.act({ kind: "wait", timeMs: 2000 });

// Get snapshot (includes all messages)
const snapshot = await browser.snapshot();

// Snapshot contains page text and elements
```

### 2. Send Messages

```javascript
// Fill message input
await browser.act({
  kind: "fill",
  selector: '[data-qa="message_input"]',
  text: "Your message here"
});

// Press Enter to send
await browser.act({
  kind: "press",
  key: "Enter"
});
```

### 3. Search Messages

```javascript
// Open search (Cmd+F)
await browser.act({
  kind: "press",
  key: "Meta+F"
});

// Type search query
await browser.act({
  kind: "type",
  text: "project deadline"
});

// Wait for results
await browser.act({ kind: "wait", timeMs: 1500 });

// Get search results
const results = await browser.snapshot();
```

## Finding Workspace and Channel IDs

### From URL

Open Slack Web, copy IDs from URL:
```
https://app.slack.com/client/T01ABCDEFG/C02HIJKLMN
                              ↑           ↑
                         Workspace ID  Channel ID
```

### From API (if you have token)

```bash
curl -H "Authorization: Bearer xoxp-..." \
  https://slack.com/api/conversations.list
```

## Integration with OpenClaw

### Periodic Check

```javascript
async function checkSlackMessages() {
  // Open channel
  await browser.open("https://app.slack.com/client/T123/C456");
  await browser.act({ kind: "wait", timeMs: 2000 });
  
  // Get content
  const snapshot = await browser.snapshot();
  
  // Analyze with AI
  const summary = await ai.analyze(snapshot);
  
  // Reply if needed
  if (summary.needsReply) {
    await browser.act({
      kind: "fill",
      selector: '[data-qa="message_input"]',
      text: summary.replyText
    });
    
    await browser.act({ kind: "press", key: "Enter" });
  }
}
```

### Cron Job

```bash
openclaw cron add \
  --name "Slack check" \
  --schedule "0 */2 * * *" \
  --payload '{"kind":"agentTurn","message":"Check Slack and summarize"}'
```

## Advantages

| Feature | Slack Web Helper | CDP Desktop |
|---------|------------------|-------------|
| **Occupies Desktop App** | ❌ No | ✅ Yes |
| **Background** | ✅ Yes | ❌ No |
| **Login** | ✅ Reuse browser | ✅ Reuse app |
| **Setup** | ✅ Zero config | ❌ Restart required |
| **Stability** | ✅ High | ⚠️ Medium |

## Limitations

1. **Login required** - Ensure browser is logged into Slack Web
2. **Need IDs** - Workspace and Channel IDs required
3. **Speed** - Slower than API (page load time)
4. **DOM changes** - Slack updates may require selector adjustments

## Troubleshooting

### Can't find message input

Try different selectors:

```javascript
'[data-qa="message_input"]'
'[role="textbox"][aria-label*="message"]'
'.ql-editor'
```

### Slow page load

Increase wait time:

```javascript
await browser.act({ kind: "wait", timeMs: 5000 });
```

## Complete Example

See [references/read-messages.md](references/read-messages.md) for detailed examples.

## Resources

- **OpenClaw Browser Tool**: Built-in tool
- **Slack Web**: https://app.slack.com
- **Agent Skills Repo**: https://github.com/roy-songzhe-li/agent-skills
