---
name: skill-creator
description: Creates Agent Skills following the official agentskills.io specification. Validates names and descriptions, generates proper directory structure with YAML frontmatter. If user request is unclear, asks 1-3 clarifying questions to refine requirements before creation. Use when creating new skills, converting scripts into skills, or validating skill structure.
license: MIT
metadata:
  author: roy-songzhe-li
  version: "2.2.0"
  updated: "2026-03-26"
  spec-version: "1.0"
  changelog: "Added requirement clarification - asks brief questions when request unclear"
---

# Skill Creator

Create Agent Skills that follow the official [agentskills.io](https://agentskills.io) specification.

## Process Overview

1. Validate skill name and description
2. Create directory structure
3. Generate SKILL.md with YAML frontmatter
4. Create optional directories (references/, assets/)
5. Generate README.md

## Step 1: Validate Skill Name

**Requirements (from spec):**
- 1-64 characters
- Lowercase letters (a-z), numbers (0-9), hyphens (-) only
- Must NOT start or end with hyphen
- Must NOT contain consecutive hyphens (--)
- Must match directory name

**Validation Rules:**

✅ **Valid Names:**
- `pdf-processing`
- `data-analysis`
- `code-review`
- `github-pr-helper`

❌ **Invalid Names:**
- `PDF-Processing` (uppercase not allowed)
- `-pdf` (starts with hyphen)
- `pdf-` (ends with hyphen)
- `pdf--processing` (consecutive hyphens)
- `pdf_processing` (underscore not allowed)
- `very-long-name-that-exceeds-the-sixty-four-character-limit-for-skill-names` (> 64 chars)

**Validation Check:**
```bash
# Length check
if [[ ${#name} -lt 1 || ${#name} -gt 64 ]]; then
  echo "Error: Name must be 1-64 characters"
fi

# Character check
if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
  echo "Error: Only lowercase letters, numbers, and hyphens allowed"
fi

# Leading/trailing hyphen check
if [[ "$name" =~ ^- || "$name" =~ -$ ]]; then
  echo "Error: Cannot start or end with hyphen"
fi

# Consecutive hyphen check
if [[ "$name" =~ -- ]]; then
  echo "Error: No consecutive hyphens allowed"
fi
```

## Step 2: Validate Description

**Requirements (from spec):**
- 1-1024 characters
- Must describe WHAT the skill does
- Must describe WHEN to use it
- Should include specific keywords for matching

**Good Description Example:**
```
Extract PDF text, fill forms, and merge files. Use when working with PDF documents, form filling, or document processing.
```

**Poor Description Example:**
```
Helps with PDFs.
```

**Include:**
- What it does (actions/capabilities)
- When to use it (triggers/scenarios)
- Specific keywords (PDF, forms, documents, etc.)

## Step 3: Create Directory Structure

```bash
mkdir <skill-name>
mkdir <skill-name>/references  # Optional but recommended
mkdir <skill-name>/assets       # Optional
```

**Standard Structure:**
```
skill-name/
├── SKILL.md          # Required
├── README.md         # Recommended
├── references/       # Optional (detailed docs)
└── assets/           # Optional (templates, resources)
```

## Step 4: Generate SKILL.md

Create `SKILL.md` with YAML frontmatter:

```markdown
---
name: <skill-name>
description: <description>
license: MIT
metadata:
  author: <your-name>
  version: "1.0.0"
  created: <YYYY-MM-DD>
---

# <Skill Title>

<Description>

## Usage

TODO: Add usage instructions

## Features

TODO: List key features

## Examples

TODO: Add examples

## Notes

TODO: Add important notes or limitations
```

**Complete Example:**

```markdown
---
name: pdf-processor
description: Extract text from PDFs, fill forms, and merge multiple files. Use when working with PDF documents, form filling, or document processing.
license: MIT
metadata:
  author: john-doe
  version: "1.0.0"
  created: 2026-03-23
---

# PDF Processor

Process PDF files: extract text, fill forms, and merge documents.

## Usage

### Extract Text

```bash
# Read PDF and extract text
# (Use available tools to read PDF files)
```

### Fill Forms

```bash
# Fill PDF form fields
# (Instructions for form filling)
```

## Features

- Text extraction from PDFs
- Form field filling
- PDF merging
- Metadata preservation

## Examples

### Extract Text from Invoice
```bash
# Example command
```

### Batch Process PDFs
```bash
# Example workflow
```

## Notes

- Supports encrypted PDFs (requires password)
- Preserves document metadata
- Handles multi-page documents
```

## Step 5: Generate README.md

Create `README.md` with basic info:

```markdown
# <skill-name>

<description>

## Installation

Copy this skill to your skills directory:

\`\`\`bash
cp -r <skill-name> ~/.your-agent/skills/
\`\`\`

## Usage

See [SKILL.md](SKILL.md) for detailed instructions.

## License

MIT
```

## Step 6: Create Reference Files (Optional)

If the skill needs detailed documentation, create reference files:

**references/REFERENCE.md:**
```markdown
# <Skill Name> Reference

Detailed technical reference.

## API Reference

TODO: Add detailed API docs

## Configuration

TODO: Add configuration options

## Advanced Usage

TODO: Add advanced examples
```

**references/EXAMPLES.md:**
```markdown
# Examples

## Basic Example

TODO: Add basic usage example

## Advanced Example

TODO: Add advanced usage example

## Edge Cases

TODO: Document edge cases
```

## Complete Creation Example

### Scenario: Create a "json-formatter" skill

**1. Validate name:**
```
Name: json-formatter
✅ Valid (lowercase, hyphen, no leading/trailing hyphens)
```

**2. Validate description:**
```
Description: Format and validate JSON files with syntax highlighting. Use when formatting JSON, validating JSON syntax, or pretty-printing JSON data.
✅ Valid (< 1024 chars, describes what + when + keywords)
```

**3. Create directory:**
```bash
mkdir json-formatter
mkdir json-formatter/references
```

**4. Create SKILL.md:**

```markdown
---
name: json-formatter
description: Format and validate JSON files with syntax highlighting. Use when formatting JSON, validating JSON syntax, or pretty-printing JSON data.
license: MIT
metadata:
  author: jane-smith
  version: "1.0.0"
  created: 2026-03-23
---

# JSON Formatter

Format and validate JSON files.

## Usage

### Format JSON

Read the JSON file, parse it, and output formatted version:

\`\`\`bash
# Read JSON file
Read input.json

# Format with jq (if available)
jq '.' input.json > output.json
\`\`\`

### Validate JSON

\`\`\`bash
# Check if valid JSON
jq empty input.json
# Exits 0 if valid, non-zero if invalid
\`\`\`

## Features

- JSON syntax validation
- Pretty-printing with indentation
- Minification support
- Syntax error reporting

## Examples

### Format a JSON File
\`\`\`bash
jq '.' messy.json > formatted.json
\`\`\`

### Validate and Report Errors
\`\`\`bash
jq empty config.json 2>&1
\`\`\`

## Notes

- Requires `jq` command-line tool
- Preserves original file if validation fails
- Supports large JSON files (streaming)
```

**5. Create README.md:**

```markdown
# json-formatter

Format and validate JSON files with syntax highlighting. Use when formatting JSON, validating JSON syntax, or pretty-printing JSON data.

## Installation

\`\`\`bash
cp -r json-formatter ~/.your-agent/skills/
\`\`\`

## Usage

See [SKILL.md](SKILL.md) for detailed instructions.

## Requirements

- `jq` command-line tool

## License

MIT
```

**6. Done!**

Directory structure:
```
json-formatter/
├── SKILL.md
├── README.md
└── references/
```

## Tips

1. **Keep SKILL.md concise** - Move detailed docs to references/
2. **Use clear descriptions** - Include what + when + keywords
3. **Provide examples** - Show don't tell
4. **Validate before creating** - Check name and description first
5. **Follow progressive disclosure** - Brief SKILL.md, detailed references/

## Common Patterns

See [references/EXAMPLES.md](references/EXAMPLES.md) for 6 common skill patterns:
1. Simple instruction skill (no scripts)
2. Tool wrapper skill
3. Reference-heavy skill (extensive docs)
4. Multi-step workflow skill
5. API integration skill
6. Template generator skill

## Specification

See [references/SPEC.md](references/SPEC.md) for the complete Agent Skills specification from agentskills.io.

---

## ⚠️ Important Principles

### 1. Avoid Stating the Obvious

**Core principle:** Don't repeat what AI already knows.

Claude understands:
- Basic programming concepts
- Common tools and commands
- General best practices

Focus on:
- Non-obvious, domain-specific knowledge
- Where Claude tends to make mistakes
- Project-specific conventions

**Example:**

❌ **Bad (obvious):**
```markdown
Python is a programming language. You can use functions to organize code.
```

✅ **Good (non-obvious):**
```markdown
In this project, always use `ruff` instead of `black` for formatting.
Configuration: `pyproject.toml` section `[tool.ruff]`
```

**Before writing, ask yourself:**
> "Does Claude already know this? If yes, delete it."

---

### 2. Description = Trigger Condition (Not Summary)

**Wrong approach:** Describe what the skill does
**Right approach:** Describe when to use it

When Claude starts, it scans all skill descriptions to decide which skills to activate.

**❌ Bad (summary):**
```yaml
description: This skill helps generate weekly reports
```

**✅ Good (trigger condition):**
```yaml
description: Trigger when user requests "weekly report", "work summary", or "standup update"
```

**Formula:**
```
description: Trigger when <user says X>, <mentions Y>, or <needs Z>
```

---

### 3. Provide Information, Not Restrictions

**Core principle:** Give Claude the information it needs, but let it adapt.

Skills are highly reusable. Over-specifying limits flexibility.

**Example: API documentation skill**

❌ **Bad (too restrictive):**
```markdown
1. Generate documentation in Markdown format
2. Include exactly 3 sections: Overview, Endpoints, Examples
3. Each endpoint must have 2 code examples
4. Use this exact heading structure: ## Endpoint Name
```

**Why bad:** User wants internal docs in different format → skill useless

✅ **Good (flexible):**
```markdown
API follows REST conventions:
- Authentication: Bearer token in header
- Response format: JSON
- Error codes: Standard HTTP status codes

See references/API-SPEC.md for detailed schema
```

**Why good:** Claude knows the API conventions, can adapt output to any format

**Principle:**
- Tell Claude WHAT the standards are
- Don't dictate HOW to apply them

---

## 🔒 Security Considerations

### ⚠️ Critical: Command Injection Prevention

**If your skill uses `exec`, you MUST prevent command injection.**

#### Dangerous Example (❌)

```markdown
# File Manager Skill

When user says "delete file [filename]":
Run: `rm [filename]`
```

**Problem:** User input "file.txt; rm -rf /" destroys the system

#### Safe Example (✅)

```markdown
# File Manager Skill

When user says "delete file [filename]":

1. **Validate filename:**
   - Only allow: letters, numbers, dots, hyphens, underscores
   - Reject: `;`, `|`, `&`, `$`, backticks, `..`

2. **Confirm with user:**
   "Delete file.txt? This cannot be undone. (yes/no)"

3. **Use safe command:**
   ```bash
   # Use trash (recoverable) instead of rm
   trash "$filename"
   ```
```

#### Input Validation Patterns

**Whitelist (preferred):**
```bash
if [[ ! "$filename" =~ ^[a-zA-Z0-9._-]+$ ]]; then
  echo "Error: Invalid filename"
  exit 1
fi
```

**Blacklist (less safe):**
```bash
if [[ "$input" =~ [;\|&\$\`] ]]; then
  echo "Error: Unsafe characters detected"
  exit 1
fi
```

#### Security Checklist

- [ ] **Input validation** - Whitelist > Blacklist
- [ ] **User confirmation** - For destructive operations
- [ ] **Recoverable actions** - `trash` > `rm`
- [ ] **Minimal permissions** - Never use `sudo`
- [ ] **Logging** - Record sensitive operations

#### Safe Command Patterns

✅ **Use quotes:**
```bash
rm "$filename"  # Quoted variable
```

❌ **Don't use unquoted:**
```bash
rm $filename  # Vulnerable
```

✅ **Use tools, not shell:**
```markdown
Use the `trash` tool instead of executing `rm` command
```

---

## 🧪 Testing Your Skill

### Local Testing Workflow

**1. Quick test:**
```bash
openclaw agent --message "your test command"
```

**2. Verify skill loaded:**
```bash
openclaw skills list | grep your-skill-name
```

**3. Interactive testing:**
```bash
openclaw agent
> test trigger phrase
> test edge case
> test error handling
```

**4. Debug mode:**
```bash
openclaw agent --message "test" --verbose
```

### Test Scenarios

**Trigger word test:**
- Does it activate with expected phrases?
- Does it ignore unrelated requests?

**Boundary test:**
- Empty input
- Very long input
- Special characters
- Missing required data

**Tool invocation test:**
- Correct commands executed?
- Proper error handling?

**Error handling test:**
- Graceful failure?
- Helpful error messages?
- Recovery suggestions?

### Test Before Sharing

Always test locally before:
- Publishing to ClawHub
- Sharing with team
- Adding to production

**Common issues caught by testing:**
- Wrong trigger words
- Missing dependencies
- Unclear instructions
- Security vulnerabilities

---

## 📦 Configuration Flow

If your skill requires user input (API keys, preferences, channels):

### 1. Store Configuration

Create `config.json` in skill directory:

```json
{
  "api_key": "",
  "notification_channel": "",
  "update_frequency": "daily"
}
```

### 2. Check and Prompt

In SKILL.md:

```markdown
## Setup

1. Check if config.json exists
2. If empty fields, ask user for values
3. Save to config.json for future use

## Configuration Prompts

- api_key: "Enter your API key (from dashboard.example.com)"
- notification_channel: "Which Slack channel? (e.g., #general)"
- update_frequency: "How often? (hourly/daily/weekly)"
```

### 3. Use AskUserQuestion Tool

For multiple-choice options:

```markdown
If configuration needed, use AskUserQuestion tool:

Options: ["#general", "#dev", "#notifications"]
Prompt: "Which Slack channel should I post to?"
```

**Benefits:**
- User doesn't retype same info
- Multiple-choice prevents typos
- Configuration persists across sessions

---

## 🌐 ClawHub Integration

### Before Creating: Search First

```bash
clawhub search "your-skill-topic"
```

**Benefits:**
- Avoid duplicate work
- Learn from existing skills
- Find complementary skills

### Publishing Your Skill

```bash
clawhub publish ./your-skill --slug your-skill --version 1.0.0
```

**Pre-publish checklist:**
- [ ] SKILL.md format correct
- [ ] Local testing passed
- [ ] README.md clear
- [ ] Dependencies documented
- [ ] LICENSE file included
- [ ] Security reviewed

### Updating Skills

```bash
# Update specific skill
clawhub update your-skill

# Update all skills
clawhub update --all
```

### Learning from ClawHub

**Browse popular skills:**
- Study their structure
- Understand community conventions
- See what triggers work well

**1000+ skills available:**
- GitHub integrations
- API wrappers
- Document processors
- Data analyzers

---

## 📚 Updated Tips

1. **Keep SKILL.md concise** - Move detailed docs to references/
2. **Use clear descriptions** - Include what + when + keywords
3. **Provide examples** - Show don't tell
4. **Validate before creating** - Check name and description first
5. **Follow progressive disclosure** - Brief SKILL.md, detailed references/
6. **Avoid stating the obvious** - Focus on non-obvious knowledge
7. **Description = trigger condition** - Not a summary
8. **Give info, not restrictions** - Let Claude adapt
9. **Security first** - Prevent command injection
10. **Test locally** - Before sharing

---

## 💬 Requirement Clarification

**When user request is unclear, ask clarifying questions. Keep it brief.**

### When to Ask

Ask ONLY when:
- ✅ Skill name is ambiguous (e.g., "data processor" - what kind of data?)
- ✅ Use case is unclear (e.g., "API skill" - which API? what operations?)
- ✅ Scope is too broad (e.g., "manage files" - specific operations needed?)
- ✅ Missing critical info (e.g., no mention of input/output format)

Don't ask when:
- ❌ Request is already specific
- ❌ Details can be inferred from context
- ❌ Information is optional

### How to Ask (Keep it Simple)

**Ask 1-3 questions maximum. Be specific.**

**❌ Bad (too many questions):**
```
What kind of data? What format? What operations? What output? 
What dependencies? What error handling? What edge cases?
```

**✅ Good (focused):**
```
Quick questions:
1. What kind of data? (JSON/CSV/PDF/other)
2. Main operation? (parse/validate/transform/merge)
```

### Question Patterns

**1. Clarify scope:**
```
"GitHub API skill" - unclear
→ Ask: "Which GitHub operations? (e.g., issues, PRs, repos, actions)"
```

**2. Identify format:**
```
"Process documents" - unclear
→ Ask: "What document types? (PDF/Word/Markdown/other)"
```

**3. Confirm use case:**
```
"Data analysis" - too broad
→ Ask: "What data source? (CSV files/API/database)"
```

**4. Get specifics:**
```
"Automation skill" - vague
→ Ask: "Automate what? (e.g., deployments, reports, tests)"
```

### Progressive Refinement

**User says:** "Make a calendar skill"

**You ask:** "Which calendar? (Google/Outlook/iCal/CLI)"

**User says:** "Google Calendar"

**You proceed:** Create `google-calendar` skill with gcalcli

---

**User says:** "Create a file manager"

**You ask:** "Main operations needed? (create/delete/organize/search)"

**User says:** "Mainly organize and search"

**You proceed:** Create `file-organizer` skill focused on those operations

---

### Don't Over-Ask

**Balance clarification with action:**
- If 80% clear → make assumptions, note them, and proceed
- If 50% clear → ask 1-2 key questions
- If completely unclear → ask 2-3 specific questions

**Example of good balance:**

**User:** "Make a skill for APIs"

**You:** "Which API? If you give me a specific API (e.g., GitHub, Stripe), I'll create a tailored skill. Or I can create a generic REST API helper."

**Don't do:**
```
What API? What endpoints? What auth? What data format? 
What error handling? What rate limits? What caching? 
What logging? What monitoring? What testing?
```

### After Clarification

Once clarified:
1. Summarize understanding
2. Proceed with skill creation
3. Note any assumptions in the skill

**Example:**

**Summary:**
```
Creating `github-issues` skill:
- Operations: list, view, create, close
- Uses: gh CLI
- Triggers: "check issue", "create issue"
```

**Proceed with creation.**
