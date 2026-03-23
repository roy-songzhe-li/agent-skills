# Address PR Comments Skill

Automatically address and reply to PR review comments with AI-powered verification and fixes.

## Quick Start

```bash
# Address all comments in a PR
bash address.sh owner/repo 123

# Only process new comments (skip already replied)
bash address.sh owner/repo 123 --new-only

# Address a specific comment
bash address.sh owner/repo 123 --comment-id 456789
```

## Features

- ✅ Read all PR review comments
- ✅ Track already addressed comments (avoid duplicates)
- ✅ Verify if comment is a valid issue (LLM-powered)
- ✅ Generate fix suggestions
- ✅ Reply directly to original comment (threaded reply, not a new comment)
- ✅ Polite responses for invalid comments
- ✅ English-only, no dashes

## Reply Formats

### Fixed Comment

```
Fixed in <commit-hash>: <one-sentence description>
```

**Example:**
```
Fixed in f2add5a: findLambda now constructs the exact expected name instead of using includes().
```

### Invalid Comment

```
This is outside the scope of this PR. Perhaps we could address it in a follow-up?
```

## Documentation

- **[SKILL.md](SKILL.md)** - Complete skill guide (official format)
- **[scripts/address.sh](scripts/address.sh)** - Main processing script
- **[references/FIXED-REPLIES.md](references/FIXED-REPLIES.md)** - Examples of fixed comment replies
- **[references/INVALID-REPLIES.md](references/INVALID-REPLIES.md)** - Examples of invalid comment replies

## Requirements

- `gh` CLI - GitHub CLI tool
- `git` - Version control
- OpenClaw with LLM access (or configure `API_BASE_URL` and `API_MODEL`)

## Configuration

```bash
# LLM API configuration
export API_BASE_URL="http://localhost:11434/v1"
export API_MODEL="anthropic/claude-sonnet-4-5"
export API_KEY="your-api-key"
```

## Workflow

1. **Fetch comments** from PR
2. **Verify validity** with LLM
3. **Generate fix** if valid
4. **Apply fix** and commit
5. **Reply** to original comment

## State Tracking

The script maintains a state file (`.addressed-comments.json`) to avoid re-processing comments:

```json
{
  "pr_123": {
    "comment_456": {
      "status": "fixed",
      "commit": "f2add5a",
      "timestamp": "2026-03-23T19:00:00Z"
    },
    "comment_789": {
      "status": "invalid",
      "reason": "out of scope",
      "timestamp": "2026-03-23T19:05:00Z"
    }
  }
}
```

## Integration

### CI/CD

```yaml
name: Address PR Comments
on:
  pull_request_review_comment:
    types: [created]

jobs:
  address:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Address Comment
        run: bash address.sh ${{ github.repository }} ${{ github.event.pull_request.number }}
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### OpenClaw

```
Address comments in PR #123
```

## Tips

1. **Review before committing** - Check suggested fixes
2. **Use --new-only** - Skip already addressed comments
3. **Be polite** - Use tentative language for invalid comments
4. **Reference commits** - Always include commit hash in fixes
5. **Avoid dashes** - Use commas or periods instead

## License

MIT
