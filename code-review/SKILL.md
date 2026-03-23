---
name: code-review
description: Automated PR code review following project AGENTS.md architecture rules. Identifies bugs, security issues, architecture violations, and test gaps. Posts inline GitHub comments. Use when reviewing pull requests or code changes.
license: MIT
compatibility: Requires gh CLI, git, and access to GitHub API
metadata:
  author: roy-songzhe-li
  version: "1.0.0"
  updated: "2026-03-23"
---

# Code Review

Automated code review that reads project-specific architecture rules and posts inline GitHub comments.

## Quick Start

```bash
scripts/review.sh owner/repo 123
```

## What This Skill Does

1. **Reads project rules** from `AGENTS.md` (if exists)
2. **Analyzes PR diff** line by line
3. **Identifies issues:**
   - Security vulnerabilities
   - Architecture violations
   - Potential bugs
   - Code duplication (DRY)
   - Type safety issues
   - Test coverage gaps
4. **Posts inline comments** directly on code
5. **Submits review** (Approve/Request Changes/Comment)

## Features

- ✅ Project-specific rules (reads AGENTS.md)
- ✅ Inline GitHub comments at exact code locations
- ✅ Tentative, constructive language
- ✅ Categorized feedback (Security, Architecture, Bug, etc.)
- ✅ Test gap identification
- ✅ Avoids duplicate comments
- ✅ LLM-powered analysis

## Usage

### Review a PR

```bash
scripts/review.sh owner/repo 123
```

### Dry Run (Preview Only)

```bash
scripts/review.sh owner/repo 123 --dry-run
```

## Comment Categories

- `Security:` - Security vulnerabilities or risks
- `Architecture:` - Architectural concerns or violations
- `Potential Bug:` - Possible runtime errors
- `DRY:` - Code duplication
- `Type Safety:` - Type-related issues
- `Performance:` - Performance concerns
- `Test Gap:` - Missing test coverage
- `[NITPICK]` - Optional minor improvements

## Review Principles

### Tentative Language ✅

- "Perhaps we could..."
- "Might be worth considering..."
- "Could potentially simplify..."
- "Would it make sense to..."

### Avoid ❌

- "You should..."
- "This is wrong..."
- "Must change..."

## Architecture Rules

Rules are read from the project's `AGENTS.md` file. If not found, uses general best practices.

See [references/ARCHITECTURE-RULES-EXAMPLE.md](references/ARCHITECTURE-RULES-EXAMPLE.md) for an example ruleset.

## Configuration

Set environment variables:

```bash
export API_MODEL="anthropic/claude-sonnet-4-5"
export API_BASE_URL="http://localhost:11434/v1"
export API_KEY="your-api-key"
```

## Examples

See [references/GOOD-COMMENTS.md](references/GOOD-COMMENTS.md) for excellent review comment examples.

See [references/BAD-COMMENTS.md](references/BAD-COMMENTS.md) for patterns to avoid.

## Review Status

Based on issue severity:

- **APPROVE** - No issues or only nitpicks
- **COMMENT** - Suggestions but not blocking
- **REQUEST_CHANGES** - Blocker issues found

## Notes

- Requires GitHub CLI (`gh`) authenticated
- Works with any GitHub repository
- Respects existing review comments (no duplicates)
- LLM analyzes code for smart feedback
