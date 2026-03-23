# Code Review Skill

Automated code review tool based on predefined architecture rules and best practices.

## Quick Start

```bash
# Review a PR
bash review.sh owner/repo 123

# Dry run (don't post comments)
bash review.sh owner/repo 123 --dry-run
```

## Features

- ✅ Pull GitHub PR diffs and analyze line-by-line
- ✅ Read project architecture rules from AGENTS.md
- ✅ Generate concise, clear review comments with tentative language
- ✅ Post inline comments directly to the code
- ✅ Support Approve / Request Changes / Comment review states
- ✅ Identify test gaps and missing coverage
- ✅ Avoid duplicate comments
- ✅ LLM-powered analysis

## Documentation

- **[SKILL.md](SKILL.md)** - Complete skill guide (official format)
- **[scripts/review.sh](scripts/review.sh)** - Main review script
- **[assets/review-prompt.txt](assets/review-prompt.txt)** - LLM prompt template
- **[references/ARCHITECTURE-RULES-EXAMPLE.md](references/ARCHITECTURE-RULES-EXAMPLE.md)** - Example architecture rules
- **[references/GOOD-COMMENTS.md](references/GOOD-COMMENTS.md)** - Excellent review comment examples
- **[references/BAD-COMMENTS.md](references/BAD-COMMENTS.md)** - Bad review comment examples (avoid)

**Note:** The skill reads architecture rules from the project's `AGENTS.md` file, not from the example file.

## Requirements

- `gh` CLI - GitHub CLI tool
- OpenClaw with LLM access (or configure `API_BASE_URL` and `API_MODEL`)

## Configuration

Set environment variables to customize:

```bash
# LLM API configuration
export API_BASE_URL="http://localhost:11434/v1"  # Default: Ollama
export API_MODEL="anthropic/claude-sonnet-4-5"   # Default model
export API_KEY="your-api-key"                    # Optional (Ollama doesn't need)
```

## Example Output

```
📋 Reviewing PR #123 in aetheron/api
⟳ Fetching PR diff...
✓ Fetched 450 lines of diff
⟳ Checking existing review comments...
⟳ Preparing review prompt...
⟳ Analyzing code with LLM...
✓ Review complete: 3 comments, status: COMMENT
⟳ Posting inline comments...
✓ Posted 3 inline comments

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✨ Review complete for PR #123
Status: COMMENT
Summary: Found several improvements worth considering
Comments: 3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
View PR: https://github.com/aetheron/api/pull/123
```

## Integration

### CI/CD

Add to `.github/workflows/code-review.yml`:

```yaml
name: AI Code Review
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: AI Review
        run: bash review.sh ${{ github.repository }} ${{ github.event.pull_request.number }}
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### OpenClaw

Use via OpenClaw agent:

```
Review PR #123 in aetheron/api
```

The agent will automatically invoke this skill.

## License

MIT
