---
name: address-pr-comments
description: Automatically address and reply to PR review comments. Verifies if comments are valid issues, generates fixes, and replies directly to original comments with threaded replies. Use when responding to PR feedback or addressing review comments.
license: MIT
compatibility: Requires gh CLI, git, and access to GitHub API
metadata:
  author: roy-songzhe-li
  version: "2.0.0"
  updated: "2026-03-23"
---

# Address PR Comments

Process PR review comments, verify validity, generate fixes, and reply with threaded responses.

## Process Overview

1. Fetch PR review comments
2. Filter already-replied comments
3. Verify each comment's validity
4. Generate fix (if valid) or explanation (if invalid)
5. Apply fix and commit (if valid)
6. Reply to original comment

## Step 1: Fetch PR Review Comments

```bash
gh api "/repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/comments"
```

**Example:**
```bash
gh api "/repos/myorg/myrepo/pulls/123/comments" --jq '.[] | {id, body, path, line, user: .user.login}'
```

This returns all review comments with their IDs, content, file paths, and authors.

## Step 2: Filter Already-Replied Comments

Check each comment for existing replies:

```bash
gh api "/repos/<OWNER>/<REPO>/pulls/comments/<COMMENT_ID>"
```

Look for the `in_reply_to_id` field in other comments. If a comment already has replies, skip it (when using `--new-only` mode).

Alternatively, maintain a local state file (`.addressed-comments.json`) to track processed comments:

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

## Step 3: Verify Comment Validity

For each comment, determine if it's a valid issue that should be fixed.

**Ask yourself:**
1. Is this a real issue (bug, security risk, or improvement)?
2. Is it within the scope of this PR?
3. Is it technically feasible to fix now?
4. Is it already addressed elsewhere?

**Valid Comment (Fix It) ✅**

Conditions:
- Legitimate bug or security issue
- Reasonable improvement suggestion
- Within PR scope
- Not already handled

**Invalid Comment (Explain) ❌**

Conditions:
- Out of scope for this PR
- Already fixed in another commit
- Intentional design decision
- Needs further discussion
- Not a real issue (misunderstanding)

## Step 4A: Generate Fix (If Valid)

If the comment is valid, generate a code fix:

1. **Read the current file:**
   ```bash
   Read <FILE_PATH>
   ```

2. **Identify the exact change needed**

3. **Apply the fix:**
   ```bash
   # Edit the file to fix the issue
   # Use whatever method works (sed, direct edit, etc.)
   ```

4. **Commit the change:**
   ```bash
   git add <FILE_PATH>
   git commit -m "Fix: <one-sentence description>"
   ```

5. **Get the commit hash:**
   ```bash
   git rev-parse --short HEAD
   ```

6. **Prepare fixed reply:**
   ```
   Fixed in <COMMIT_HASH>: <one-sentence description of what changed>
   ```

## Step 4B: Generate Explanation (If Invalid)

If the comment is invalid, generate a polite explanation:

**Common scenarios:**

**Out of Scope:**
```
This is outside the scope of this PR. Perhaps we could address it in a follow-up?
```

**Already Fixed:**
```
This was already addressed in commit abc123.
```

**Intentional Design:**
```
The current implementation is intentional because [reason]. Could you clarify your concern?
```

**Needs Discussion:**
```
Thanks for the suggestion. Could we discuss this further? I think [your perspective].
```

**Not a Real Issue:**
```
[Explanation of why it's not an issue]. Could you clarify if you see a specific problem?
```

## Step 5: Reply to Comment

Use GitHub's threaded reply API:

```bash
gh api --method POST \
  -H "Accept: application/vnd.github+json" \
  "/repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/comments/<COMMENT_ID>/replies" \
  -f body="<REPLY_TEXT>"
```

**Important:**
- This creates a **threaded reply** under the original comment
- NOT a new standalone review comment
- NOT a quote-style reply
- The reply appears directly below the original comment

**Example (Fixed):**
```bash
gh api --method POST \
  "/repos/myorg/myrepo/pulls/123/comments/456789/replies" \
  -f body="Fixed in f2add5a: findLambda now constructs the exact expected name instead of using includes()."
```

**Example (Invalid):**
```bash
gh api --method POST \
  "/repos/myorg/myrepo/pulls/123/comments/789012/replies" \
  -f body="This is outside the scope of this PR. Perhaps we could address it in a follow-up?"
```

## Reply Format Rules

### Fixed Comment Format

```
Fixed in <hash>: <one-sentence description>
```

**Rules:**
- ✅ Include short commit hash (7-8 characters)
- ✅ One sentence describing the change
- ✅ Explain what was changed, not why
- ✅ Use English
- ❌ No dashes (em dash —, en dash –)
- ❌ Keep it concise

**Good Examples:**

```
Fixed in f2add5a: findLambda now constructs the exact expected name instead of using includes().
```

```
Fixed in 8c3f912: replaced getDb() with request.db() to enforce row-level security.
```

```
Fixed in 9d2a7f5: switched to date-fns addDays() for DST-safe expiry calculation.
```

### Invalid Comment Format

**Rules:**
- ✅ One sentence explanation
- ✅ Polite, humble tone
- ✅ Use tentative language ("Perhaps", "Could", "Might")
- ✅ Suggest alternatives when applicable
- ✅ Use English
- ❌ No dashes
- ❌ Don't be dismissive or defensive

**Good Examples:**

```
This is outside the scope of this PR. Perhaps we could address it in a follow-up?
```

```
This was already addressed in commit abc123.
```

```
The current implementation is intentional because we need concurrent execution. Could you clarify if you see a specific issue?
```

```
Thanks for the suggestion. Could we discuss this further? I think the current approach balances simplicity and flexibility.
```

## Complete Example

### Scenario: Review comment about missing null check

**Comment:**
> Missing null check for `result.data`.

**Process:**

1. **Fetch comment:**
   ```bash
   gh api "/repos/myorg/myrepo/pulls/123/comments" --jq '.[] | select(.id == 456789)'
   ```

2. **Verify validity:** Yes, this is a valid issue (potential bug)

3. **Read file:**
   ```bash
   Read src/services/api.ts
   ```

4. **Apply fix:**
   ```typescript
   // Before:
   const value = result.data.value;
   
   // After:
   if (!result.data) {
     throw new Error('API returned no data');
   }
   const value = result.data.value;
   ```

5. **Commit:**
   ```bash
   git add src/services/api.ts
   git commit -m "Fix: add null check for result.data"
   git rev-parse --short HEAD
   # Output: a7c3f21
   ```

6. **Reply:**
   ```bash
   gh api --method POST \
     "/repos/myorg/myrepo/pulls/123/comments/456789/replies" \
     -f body="Fixed in a7c3f21: added null check for result.data to prevent runtime errors."
   ```

## Tips

1. **Be thorough** - Read the full context before deciding if valid
2. **One fix per commit** - Keep commits focused
3. **Clear commit messages** - Use format: "Fix: <description>"
4. **Polite explanations** - Even when declining, be respectful
5. **No dashes** - Use commas or "and" instead
6. **English only** - All replies in English

## References

- [Fixed reply examples](references/FIXED-REPLIES.md) - 18 examples of good fixed replies
- [Invalid reply examples](references/INVALID-REPLIES.md) - 20 scenarios for invalid comments

## State Tracking (Optional)

Maintain `.addressed-comments.json` to avoid re-processing:

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

Update this file after processing each comment to track what's been addressed.
