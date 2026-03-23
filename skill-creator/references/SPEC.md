<!-- This is a condensed version of the official Agent Skills specification from agentskills.io -->

# Agent Skills Specification

Based on [agentskills.io/specification](https://agentskills.io/specification)

## Directory Structure

```
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
└── assets/           # Optional: templates, resources
```

## SKILL.md Format

Must contain YAML frontmatter followed by Markdown content.

### Required Frontmatter Fields

| Field | Constraints |
|-------|------------|
| `name` | 1-64 characters. Lowercase letters, numbers, hyphens only. No leading/trailing hyphens. No consecutive hyphens. Must match directory name. |
| `description` | 1-1024 characters. Non-empty. Describes what the skill does AND when to use it. |

### Optional Frontmatter Fields

| Field | Description |
|-------|-------------|
| `license` | License name or reference to bundled license file |
| `compatibility` | Max 500 characters. Environment requirements (product, packages, network) |
| `metadata` | Arbitrary key-value mapping for additional metadata |
| `allowed-tools` | Space-delimited list of pre-approved tools (experimental) |

### Frontmatter Example

```yaml
---
name: pdf-processing
description: Extract PDF text, fill forms, merge files. Use when working with PDF documents.
license: Apache-2.0
compatibility: Requires Python 3.8+ and poppler-utils
metadata:
  author: example-org
  version: "1.0"
allowed-tools: Bash(python3:*) Read
---
```

## Name Validation Rules

✅ **Valid:**
- `pdf-processing`
- `data-analysis`
- `code-review`

❌ **Invalid:**
- `PDF-Processing` (uppercase not allowed)
- `-pdf` (cannot start with hyphen)
- `pdf--processing` (consecutive hyphens not allowed)
- `pdf_processing` (underscores not allowed)

## Description Best Practices

**Good:**
```yaml
description: Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents or when the user mentions PDFs, forms, or document extraction.
```

**Poor:**
```yaml
description: Helps with PDFs.
```

Include:
- What the skill does
- When to use it
- Specific keywords for matching

## Progressive Disclosure

Structure skills for efficient context use:

1. **Metadata** (~100 tokens) - name + description, loaded at startup
2. **Instructions** (< 5000 tokens, < 500 lines) - SKILL.md body, loaded when activated
3. **Resources** (as needed) - scripts/, references/, assets/ loaded on demand

**Recommendation:** Keep SKILL.md < 500 lines. Move detailed content to references/.

## Optional Directories

### `scripts/`
Executable code agents can run. Should be:
- Self-contained or document dependencies
- Include helpful error messages
- Handle edge cases gracefully

### `references/`
Additional documentation loaded on demand:
- `REFERENCE.md` - Detailed technical reference
- `FORMS.md` - Form templates
- Domain-specific files (`finance.md`, `legal.md`)

Keep files focused. Smaller files = less context usage.

### `assets/`
Static resources:
- Templates (documents, configs)
- Images (diagrams, examples)
- Data files (lookup tables, schemas)

## File References

Use relative paths from skill root:

```markdown
See [the reference guide](references/REFERENCE.md) for details.

Run the extraction script:
scripts/extract.py
```

Keep references one level deep. Avoid deeply nested chains.

## Validation

Official validator: [skills-ref](https://github.com/agentskills/agentskills/tree/main/skills-ref)

```bash
skills-ref validate ./my-skill
```

Checks:
- Valid YAML frontmatter
- Name follows spec constraints
- Description within limits
- Directory structure

## Complete Example

### Minimal Skill

```markdown
---
name: hello-world
description: Prints a greeting message. Use when you need to say hello or test basic functionality.
---

# Hello World

This skill prints a simple greeting message.

## Usage

Just ask for a greeting and I'll say hello!
```

### Full-Featured Skill

```
pdf-tools/
├── SKILL.md
├── scripts/
│   ├── extract-text.py
│   ├── fill-form.py
│   └── merge-pdfs.sh
├── references/
│   ├── REFERENCE.md
│   └── FORMS.md
└── assets/
    ├── template.pdf
    └── schema.json
```

```markdown
---
name: pdf-tools
description: Extract text, fill forms, and merge PDF files. Use when working with PDF documents or automation.
license: Apache-2.0
compatibility: Requires Python 3.8+, poppler-utils, and PyPDF2
metadata:
  author: example-org
  version: "2.1.0"
  docs: https://example.com/pdf-tools
---

# PDF Tools

Comprehensive PDF processing capabilities.

## Quick Start

```bash
scripts/extract-text.py input.pdf output.txt
```

## Features

- Extract text and tables
- Fill form fields
- Merge multiple PDFs
- Split large documents

See [references/REFERENCE.md](references/REFERENCE.md) for detailed API documentation.

## Examples

### Extract Text
```bash
scripts/extract-text.py document.pdf
```

### Fill Form
```bash
scripts/fill-form.py template.pdf data.json output.pdf
```

## Notes

- Supports encrypted PDFs (requires password)
- Handles OCR for scanned documents
- Preserves metadata and annotations
```

## Additional Resources

- [Official Specification](https://agentskills.io/specification)
- [Example Skills Repository](https://github.com/anthropics/skills)
- [Skills Reference Library](https://github.com/agentskills/agentskills/tree/main/skills-ref)
