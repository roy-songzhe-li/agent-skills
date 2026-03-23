# Skill Examples and Patterns

Common patterns and examples for creating Agent Skills.

## Pattern 1: Simple Instruction Skill

**When to use:** Procedural knowledge without executable code

```markdown
---
name: meeting-notes
description: Creates structured meeting notes with attendees, agenda, and action items. Use when documenting meetings or creating meeting summaries.
---

# Meeting Notes

Generate well-structured meeting notes following company format.

## Format

**Meeting:** [Title]
**Date:** [Date]
**Attendees:** [Names]

**Agenda:**
1. [Item 1]
2. [Item 2]

**Discussion:**
- [Key points]

**Action Items:**
- [ ] [Task] - Assigned to [Person] - Due [Date]

**Next Steps:**
[Summary]

## Guidelines

- Always include date and attendees
- Action items must have assignees and due dates
- Keep discussion points concise
- Link related documents
```

---

## Pattern 2: Script-Based Skill

**When to use:** Executable automation or data processing

```
data-analyzer/
├── SKILL.md
└── scripts/
    ├── analyze.py
    └── visualize.py
```

```markdown
---
name: data-analyzer
description: Analyzes CSV data and generates statistical reports with visualizations. Use when analyzing datasets or creating data reports.
compatibility: Requires Python 3.8+, pandas, matplotlib
---

# Data Analyzer

Perform statistical analysis and generate visualizations for CSV datasets.

## Usage

```bash
scripts/analyze.py data.csv --output report.pdf
```

## Features

- Descriptive statistics
- Correlation analysis
- Trend visualization
- Outlier detection

## Options

- `--output`: Output file path (default: report.pdf)
- `--format`: Output format (pdf, html, json)
- `--stats-only`: Skip visualizations

## Examples

### Basic Analysis
```bash
scripts/analyze.py sales_data.csv
```

### Custom Output
```bash
scripts/analyze.py sales_data.csv --output monthly_report.html --format html
```
```

---

## Pattern 3: Reference-Heavy Skill

**When to use:** Domain expertise with extensive documentation

```
legal-review/
├── SKILL.md
├── references/
│   ├── REFERENCE.md
│   ├── CHECKLIST.md
│   └── TEMPLATES.md
└── assets/
    └── contract-template.docx
```

```markdown
---
name: legal-review
description: Reviews contracts and legal documents against compliance checklist. Use when reviewing legal documents or contracts.
license: Proprietary
compatibility: Designed for legal teams with access to company templates
---

# Legal Review

Review legal documents for compliance with company standards.

## Process

1. Check document against [checklist](references/CHECKLIST.md)
2. Verify terms against company policy
3. Flag missing clauses
4. Suggest revisions

See [references/REFERENCE.md](references/REFERENCE.md) for detailed legal requirements.

## Quick Check

For standard contracts, use:
- [Templates](references/TEMPLATES.md) for common clauses
- [Checklist](references/CHECKLIST.md) for compliance items

## Notes

- Always involve legal team for final approval
- Document all changes and rationale
- Keep audit trail
```

---

## Pattern 4: Multi-Language Tool

**When to use:** Supporting multiple programming languages or file types

```
code-formatter/
├── SKILL.md
└── scripts/
    ├── format-python.py
    ├── format-javascript.js
    └── format-go.sh
```

```markdown
---
name: code-formatter
description: Formats code files in Python, JavaScript, and Go according to style guides. Use when formatting code or enforcing code style.
compatibility: Requires black, prettier, gofmt
---

# Code Formatter

Format code files following language-specific style guides.

## Supported Languages

- **Python:** Black formatter
- **JavaScript/TypeScript:** Prettier
- **Go:** gofmt

## Usage

```bash
# Auto-detect language
scripts/format-auto.sh file.py

# Specific language
scripts/format-python.py file.py
scripts/format-javascript.js file.js
scripts/format-go.sh file.go
```

## Configuration

Each formatter uses standard configuration files:
- Python: `.black.toml`
- JavaScript: `.prettierrc`
- Go: default gofmt

## Batch Formatting

```bash
find . -name "*.py" -exec scripts/format-python.py {} \;
```
```

---

## Pattern 5: API Integration Skill

**When to use:** Integrating with external services or APIs

```
github-pr-review/
├── SKILL.md
├── scripts/
│   └── review.sh
└── references/
    └── API.md
```

```markdown
---
name: github-pr-review
description: Reviews GitHub pull requests for code quality and best practices. Use when reviewing PRs or code changes on GitHub.
compatibility: Requires gh CLI and git
---

# GitHub PR Review

Automated PR code review using GitHub API.

## Setup

```bash
gh auth login
```

## Usage

```bash
scripts/review.sh owner/repo 123
```

## Review Process

1. Fetch PR diff
2. Analyze code changes
3. Check against project guidelines
4. Post inline comments
5. Submit review (Approve/Request Changes/Comment)

See [references/API.md](references/API.md) for GitHub API details.

## Configuration

Set environment variables:
- `GITHUB_TOKEN`: GitHub personal access token
- `REVIEW_RULES`: Path to custom rules file

## Examples

### Review PR
```bash
scripts/review.sh myorg/myrepo 456
```

### Dry Run
```bash
scripts/review.sh myorg/myrepo 456 --dry-run
```
```

---

## Pattern 6: Template Generator

**When to use:** Creating documents or files from templates

```
document-generator/
├── SKILL.md
├── scripts/
│   └── generate.py
└── assets/
    ├── report-template.docx
    ├── presentation-template.pptx
    └── email-template.html
```

```markdown
---
name: document-generator
description: Generates documents from templates with variable substitution. Use when creating reports, presentations, or documents from templates.
compatibility: Requires Python 3.8+, python-docx
---

# Document Generator

Create documents from templates with dynamic content.

## Templates

- **Report:** [assets/report-template.docx](assets/report-template.docx)
- **Presentation:** [assets/presentation-template.pptx](assets/presentation-template.pptx)
- **Email:** [assets/email-template.html](assets/email-template.html)

## Usage

```bash
scripts/generate.py report data.json output.docx
```

## Data Format

```json
{
  "title": "Q1 Sales Report",
  "date": "2026-03-23",
  "author": "John Doe",
  "sections": [
    {"heading": "Overview", "content": "..."},
    {"heading": "Metrics", "content": "..."}
  ]
}
```

## Examples

### Generate Report
```bash
scripts/generate.py report q1_data.json q1_report.docx
```

### Generate Presentation
```bash
scripts/generate.py presentation sales_data.json sales_deck.pptx
```
```

---

## Best Practices

### 1. Keep SKILL.md Concise

❌ **Bad:** 1000+ lines in SKILL.md

✅ **Good:** Short SKILL.md with references

```markdown
See [references/DETAILED-GUIDE.md](references/DETAILED-GUIDE.md) for advanced usage.
```

### 2. Progressive Disclosure

Load content only when needed:

```markdown
## Basic Usage
[Quick examples here]

## Advanced
See [references/ADVANCED.md](references/ADVANCED.md) for:
- Custom configurations
- API integration
- Performance tuning
```

### 3. Clear Triggers

Help agents know when to use the skill:

✅ **Good:**
```yaml
description: Formats Python code using Black. Use when formatting .py files, enforcing PEP 8 style, or cleaning up Python code.
```

❌ **Poor:**
```yaml
description: Formats code.
```

### 4. Self-Contained Scripts

Scripts should:
- Check for dependencies
- Provide helpful error messages
- Include usage instructions

```python
#!/usr/bin/env python3
"""
Extract text from PDF files.

Usage: python extract.py input.pdf [output.txt]

Requirements: PyPDF2
"""

import sys

try:
    from PyPDF2 import PdfReader
except ImportError:
    print("Error: PyPDF2 not installed. Run: pip install PyPDF2")
    sys.exit(1)

# ... rest of script
```

### 5. Examples Over Explanation

Show don't tell:

✅ **Good:**
```markdown
## Examples

### Basic
```bash
scripts/process.py data.csv
```

### With Options
```bash
scripts/process.py data.csv --format json --output results.json
```
```

❌ **Poor:**
```markdown
The script can process CSV files and has various options including format and output specifications that can be configured...
```

---

## Anti-Patterns to Avoid

### ❌ Everything in SKILL.md

Don't put all documentation in SKILL.md. Use references/.

### ❌ No Clear Use Case

Don't create vague descriptions. Be specific about when to use.

### ❌ Hardcoded Paths

Don't hardcode file paths. Use relative paths or arguments.

### ❌ Missing Error Handling

Don't skip error messages. Scripts should fail gracefully.

### ❌ No Examples

Don't skip examples. They're the fastest way to understand usage.
