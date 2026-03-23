---
name: code-review
description: Automated PR code review following project AGENTS.md architecture rules. Identifies bugs, security issues, architecture violations, and test gaps. Posts inline GitHub comments. Use when reviewing pull requests or code changes.
license: MIT
compatibility: Requires gh CLI, git, and access to GitHub API
metadata:
  author: roy-songzhe-li
  version: "2.0.0"
  updated: "2026-03-23"
---

# Code Review

Perform automated PR code review following project-specific architecture rules.

## Process Overview

1. Fetch PR diff from GitHub
2. Read project architecture rules (AGENTS.md)
3. Check existing review comments
4. Analyze code with LLM
5. Post inline comments
6. Submit review status

## Step 1: Fetch PR Diff

```bash
gh pr diff <PR_NUMBER> --repo <OWNER/REPO>
```

**Example:**
```bash
gh pr diff 123 --repo myorg/myrepo
```

Save the diff for analysis. You'll need it for Step 4.

## Step 2: Read Project Architecture Rules

Fetch the project's AGENTS.md file (if it exists):

```bash
gh api "/repos/<OWNER>/<REPO>/contents/AGENTS.md" --jq '.content' | base64 -d
```

If AGENTS.md doesn't exist, use general best practices:
- Security (authentication, authorization, data leakage)
- Architecture (proper layering, separation of concerns)
- Type safety (avoid `any`, validate inputs)
- API design (RESTful, correct HTTP methods)
- Code quality (DRY, readability)
- Test coverage

## Step 3: Check Existing Comments

Avoid duplicate comments by checking what's already posted:

```bash
gh api "/repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/comments" --jq '.[].body'
```

Save the list of existing comment bodies to filter duplicates later.

## Step 4: Analyze Code with LLM

Review the diff against architecture rules. Look for:

**Security Issues (🔴 Blocker):**
- Authentication/authorization bypasses
- SQL injection or XSS risks
- Sensitive data exposure
- Hardcoded credentials

**Architecture Violations (🟠 Major):**
- Business logic in route handlers (should be in services)
- Direct database access without repository layer
- Missing error handling
- Bypassing security mechanisms

**Potential Bugs (🟠 Major):**
- Null pointer exceptions
- Race conditions
- Off-by-one errors
- Unhandled error cases

**Code Quality (🟡 Minor):**
- Code duplication (DRY violations)
- Poor naming
- Magic numbers
- Inconsistent patterns

**Test Gaps (🟡 Minor):**
- New functions without unit tests
- Edge cases not covered (null, empty, invalid)
- Error paths not tested
- Missing integration tests

## Step 5: Generate Review Comments

For each issue, create a comment in this format:

**Category Template:**
```
<Category>: <One sentence description>
```

**Categories:**
- `Security:`
- `Architecture:`
- `Potential Bug:`
- `DRY:`
- `Type Safety:`
- `Performance:`
- `Test Gap:`
- `[NITPICK]`

**Language Guidelines:**

✅ **Use tentative language:**
- "Perhaps we could..."
- "Might be worth considering..."
- "Could potentially simplify..."
- "Would it make sense to..."
- "It looks like... might need..."

❌ **Avoid:**
- "You should..."
- "This is wrong..."
- "Must change..."

**Good Examples:**

> **Security:** The `billingCheckoutSigningSecret` is optional in config. Consider making it required in staging/production to prevent the API from starting without proper security.

> **DRY:** Since `process()` throws on failure, `processed` is always `true`. Perhaps we could simplify the interface?

> **Test Gap:** The new `createCheckoutLink` function lacks unit tests for token expiry validation. Perhaps we could add test cases for expired tokens and invalid signatures?

See [references/GOOD-COMMENTS.md](references/GOOD-COMMENTS.md) for more examples.

## Step 6: Post Inline Comments

Use the GitHub API to post inline review comments:

```bash
gh api --method POST \
  -H "Accept: application/vnd.github+json" \
  "/repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/reviews" \
  -f body="<REVIEW_SUMMARY>" \
  -f event="<STATUS>" \
  -f 'comments[][path]=<FILE_PATH>' \
  -f 'comments[][line]=<LINE_NUMBER>' \
  -f 'comments[][body]=<COMMENT_TEXT>'
```

**Parameters:**
- `body`: Overall review summary
- `event`: One of `APPROVE`, `REQUEST_CHANGES`, or `COMMENT`
- `comments[].path`: Relative file path (e.g., `apps/api/src/routes/billing.ts`)
- `comments[].line`: Line number in the diff
- `comments[].body`: Your comment text (with category prefix)

**Example:**
```bash
gh api --method POST \
  -H "Accept: application/vnd.github+json" \
  "/repos/myorg/myrepo/pulls/123/reviews" \
  -f body="Found 3 issues to address" \
  -f event="COMMENT" \
  -f 'comments[][path]=apps/api/src/routes/billing.ts' \
  -f 'comments[][line]=42' \
  -f 'comments[][body]=Security: The billingCheckoutSigningSecret is optional. Consider making it required in production.'
```

## Step 7: Determine Review Status

Based on issue severity:

- **APPROVE** - No issues, or only `[NITPICK]` comments
- **COMMENT** - Minor/Major issues, not blocking merge
- **REQUEST_CHANGES** - Blocker issues found (Security, Critical Bugs)

**Status Mapping:**
```
🔴 Blocker issues → REQUEST_CHANGES
🟠 Major issues only → COMMENT
🟡 Minor issues only → APPROVE (with comments)
⚪ Nitpicks only → APPROVE
No issues → APPROVE with "LGTM! 🚀"
```

## Complete Example

```bash
# 1. Fetch PR diff
gh pr diff 123 --repo myorg/myrepo > /tmp/pr.diff

# 2. Read architecture rules
gh api "/repos/myorg/myrepo/contents/AGENTS.md" --jq '.content' | base64 -d > /tmp/agents.md

# 3. Check existing comments
gh api "/repos/myorg/myrepo/pulls/123/comments" --jq '.[].body' > /tmp/existing.txt

# 4. Analyze (in your head or with LLM)
# - Review diff against AGENTS.md rules
# - Identify issues
# - Generate comments (avoid duplicates from existing.txt)

# 5. Post review
gh api --method POST \
  "/repos/myorg/myrepo/pulls/123/reviews" \
  -f body="Found several improvements worth considering" \
  -f event="COMMENT" \
  -f 'comments[][path]=src/routes/billing.ts' \
  -f 'comments[][line]=20' \
  -f 'comments[][body]=Security: Missing authentication check. Perhaps we could add the auth middleware?' \
  -f 'comments[][path]=src/services/checkout.ts' \
  -f 'comments[][line]=45' \
  -f 'comments[][body]=Test Gap: No unit tests for token expiry. Would it make sense to add coverage?'
```

## Tips

1. **Read AGENTS.md first** - Project-specific rules take precedence
2. **One comment per issue** - Keep them focused and actionable
3. **Provide context** - Explain why something is an issue
4. **Suggest solutions** - Don't just point out problems
5. **Be respectful** - Use tentative language
6. **Check for duplicates** - Don't repeat existing comments

## References

- [Good comment examples](references/GOOD-COMMENTS.md)
- [Bad comment examples](references/BAD-COMMENTS.md)
- [Architecture rules example](references/ARCHITECTURE-RULES-EXAMPLE.md)
