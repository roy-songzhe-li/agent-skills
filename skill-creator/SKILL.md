---
name: skill-creator
description: Creates Agent Skills following the official agentskills.io specification. Use when you need to create a new skill, convert existing scripts into skills, or validate skill structure.
license: MIT
compatibility: Requires bash, jq for validation
metadata:
  author: roy-songzhe-li
  version: "1.0.0"
  spec-version: "1.0"
---

# Skill Creator

Create Agent Skills that follow the official [agentskills.io](https://agentskills.io) specification.

## Usage

```bash
scripts/create-skill.sh <skill-name> "<description>"
```

## What This Skill Does

1. Creates proper directory structure (scripts/, references/, assets/)
2. Generates SKILL.md with valid YAML frontmatter
3. Validates skill name and description against spec constraints
4. Provides template files for common use cases

## Quick Start

```bash
# Create a new skill
scripts/create-skill.sh my-skill "Processes CSV files and generates reports"

# Validate an existing skill
scripts/validate-skill.sh path/to/skill

# Convert existing files into a skill
scripts/convert-to-skill.sh path/to/files skill-name "description"
```

## Specification Requirements

See [references/SPEC.md](references/SPEC.md) for the complete Agent Skills specification.

### Name Requirements
- 1-64 characters
- Lowercase letters (a-z), numbers, hyphens (-) only
- No leading/trailing hyphens
- No consecutive hyphens (--)
- Must match directory name

### Description Requirements
- 1-1024 characters
- Should describe WHAT the skill does AND WHEN to use it
- Include specific keywords for agent matching

## Directory Structure

```
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: detailed docs (loaded on demand)
└── assets/           # Optional: templates, resources
```

## Progressive Disclosure Principle

- **Metadata** (~100 tokens): name + description, loaded at startup
- **Instructions** (< 500 lines): SKILL.md body, loaded when skill activated
- **Resources** (as needed): scripts/, references/, assets/ loaded on demand

Keep SKILL.md concise. Move detailed content to references/.

## Examples

See [references/EXAMPLES.md](references/EXAMPLES.md) for complete skill examples and patterns.

## Validation

All created skills are automatically validated against the official spec using skills-ref validator.
