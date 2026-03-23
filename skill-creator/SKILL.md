---
name: skill-creator
description: Creates Agent Skills following the official agentskills.io specification. Validates names and descriptions, generates proper directory structure with YAML frontmatter. Use when creating new skills, converting scripts into skills, or validating skill structure.
license: MIT
metadata:
  author: roy-songzhe-li
  version: "2.0.0"
  updated: "2026-03-23"
  spec-version: "1.0"
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
