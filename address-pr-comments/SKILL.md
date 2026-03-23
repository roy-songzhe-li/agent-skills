---
name: address-pr-comments
description: Automatically address and reply to PR review comments. Verifies if comments are valid issues, generates fixes, and replies directly to original comments. Uses LLM for validation and fix generation. Use when responding to PR feedback or addressing review comments.
license: MIT
compatibility: Requires gh CLI, git, and access to GitHub API
metadata:
  author: roy-songzhe-li
  version: "1.0.0"
  updated: "2026-03-23"
---

# Address PR Comments

Automatically process PR review comments with AI-powered verification and fixes.

## Quick Start

```bash
# Address all comments in a PR
scripts/address.sh owner/repo 123

# Only process new comments (skip already replied)
scripts/address.sh owner/repo 123 --new-only
```

## What This Skill Does

1. **Reads PR comments** - Fetches all review comments
2. **Verifies validity** - Uses LLM to determine if comment is a real issue
3. **Generates fix** - If valid, creates code fix suggestion
4. **Applies fix** - Executes code changes and commits
5. **Replies to comment** - Threaded reply under original comment

## Features

- ✅ LLM-powered comment validation
- ✅ Automatic fix generation
- ✅ Threaded replies (not new comments)
- ✅ State tracking (avoids re-processing)
- ✅ Two reply modes: Fixed / Invalid
- ✅ English-only, no dashes
- ✅ Polite, humble tone

## Reply Formats

### Fixed Comment

```
Fixed in f2add5a: findLambda now constructs the exact expected name instead of using includes().
```

**Format:** `Fixed in <hash>: <description>`

**Rules:**
- ✅ Include commit hash
- ✅ One sentence description
- ✅ Explain what changed
- ✅ Use English
- ❌ No dashes (em dash / en dash)
- ❌ Not too verbose

### Invalid Comment

```
This is outside the scope of this PR. Perhaps we could address it in a follow-up?
```

**Rules:**
- ✅ One sentence explanation
- ✅ Polite, tentative language ("Perhaps", "Could", "Might")
- ✅ Suggest alternatives if applicable
- ✅ Use English
- ❌ No dashes
- ❌ Don't be dismissive

## Validation Process

For each comment, LLM determines:

### ✅ Valid (Fix It)

**Conditions:**
- Actually a bug or improvement
- Within PR scope
- Technically feasible

**Actions:**
1. Generate fix code
2. Apply changes
3. Commit
4. Reply: `Fixed in <hash>: <description>`

### ❌ Invalid (Explain)

**Conditions:**
- Out of scope
- Already handled
- Not a real issue
- Needs discussion

**Actions:**
1. Generate polite explanation
2. Reply with reason

## Common Invalid Reasons

- `This is outside the scope of this PR. Perhaps we could address it in a follow-up?`
- `This was already addressed in commit abc123.`
- `The current implementation is intentional because [reason]. Could you clarify your concern?`
- `Thanks for the suggestion. Could we discuss this further? I think [your perspective].`

## Usage Examples

### Process All Comments
```bash
scripts/address.sh myorg/myrepo 456
```

### Only New Comments
```bash
scripts/address.sh myorg/myrepo 456 --new-only
```

### Specific Comment
```bash
scripts/address.sh myorg/myrepo 456 --comment-id 789012
```

## Configuration

Set environment variables:

```bash
export API_MODEL="anthropic/claude-sonnet-4-5"
export API_BASE_URL="http://localhost:11434/v1"
export API_KEY="your-api-key"
```

## State Tracking

The script maintains `.addressed-comments.json` to avoid re-processing:

```json
{
  "pr_123": {
    "comment_456": {
      "status": "fixed",
      "commit": "f2add5a",
      "timestamp": "2026-03-23T19:00:00Z"
    }
  }
}
```

## Reply Examples

See [references/FIXED-REPLIES.md](references/FIXED-REPLIES.md) for fixed comment examples.

See [references/INVALID-REPLIES.md](references/INVALID-REPLIES.md) for invalid comment reply examples.

## Notes

- Uses GitHub `/comments/{comment_id}/replies` API
- Replies appear under original comment (threaded)
- NOT new standalone review comments
- NOT quote-style replies
- Tracks processed comments to avoid duplicates
