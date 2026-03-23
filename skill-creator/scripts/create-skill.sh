#!/usr/bin/env bash
set -euo pipefail

# Create a new Agent Skill following the official specification
# Usage: create-skill.sh <skill-name> "<description>" [--with-scripts] [--with-references]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(dirname "${SCRIPT_DIR}")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validate arguments
if [[ $# -lt 2 ]]; then
  echo -e "${RED}Usage: create-skill.sh <skill-name> \"<description>\" [--with-scripts] [--with-references]${NC}"
  echo "Example: create-skill.sh pdf-processing \"Extract PDF text, fill forms, merge files. Use when handling PDFs.\""
  exit 1
fi

SKILL_NAME="$1"
DESCRIPTION="$2"
WITH_SCRIPTS=false
WITH_REFERENCES=false

shift 2
while [[ $# -gt 0 ]]; do
  case $1 in
    --with-scripts)
      WITH_SCRIPTS=true
      shift
      ;;
    --with-references)
      WITH_REFERENCES=true
      shift
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

# Validate skill name (spec requirements)
validate_name() {
  local name="$1"
  
  # Check length (1-64 characters)
  if [[ ${#name} -lt 1 || ${#name} -gt 64 ]]; then
    echo -e "${RED}Error: Name must be 1-64 characters${NC}"
    return 1
  fi
  
  # Check lowercase alphanumeric and hyphens only
  if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
    echo -e "${RED}Error: Name must contain only lowercase letters, numbers, and hyphens${NC}"
    return 1
  fi
  
  # Check no leading/trailing hyphens
  if [[ "$name" =~ ^- || "$name" =~ -$ ]]; then
    echo -e "${RED}Error: Name cannot start or end with a hyphen${NC}"
    return 1
  fi
  
  # Check no consecutive hyphens
  if [[ "$name" =~ -- ]]; then
    echo -e "${RED}Error: Name cannot contain consecutive hyphens${NC}"
    return 1
  fi
  
  return 0
}

# Validate description (spec requirements)
validate_description() {
  local desc="$1"
  
  # Check length (1-1024 characters)
  if [[ ${#desc} -lt 1 || ${#desc} -gt 1024 ]]; then
    echo -e "${RED}Error: Description must be 1-1024 characters${NC}"
    return 1
  fi
  
  return 0
}

echo -e "${BLUE}🚀 Creating Agent Skill: ${SKILL_NAME}${NC}"

# Validate inputs
validate_name "$SKILL_NAME" || exit 1
validate_description "$DESCRIPTION" || exit 1

echo -e "${GREEN}✓ Name and description are valid${NC}"

# Create directory
SKILL_DIR="${PWD}/${SKILL_NAME}"

if [[ -d "$SKILL_DIR" ]]; then
  echo -e "${RED}Error: Directory ${SKILL_NAME} already exists${NC}"
  exit 1
fi

mkdir -p "$SKILL_DIR"
echo -e "${GREEN}✓ Created directory: ${SKILL_DIR}${NC}"

# Create optional directories
if [[ "$WITH_SCRIPTS" == true ]]; then
  mkdir -p "$SKILL_DIR/scripts"
  echo -e "${GREEN}✓ Created scripts/ directory${NC}"
fi

if [[ "$WITH_REFERENCES" == true ]]; then
  mkdir -p "$SKILL_DIR/references"
  mkdir -p "$SKILL_DIR/assets"
  echo -e "${GREEN}✓ Created references/ and assets/ directories${NC}"
fi

# Generate SKILL.md
cat > "$SKILL_DIR/SKILL.md" <<EOF
---
name: ${SKILL_NAME}
description: ${DESCRIPTION}
license: MIT
metadata:
  author: $(git config user.name 2>/dev/null || echo "unknown")
  version: "1.0.0"
  created: $(date -u +%Y-%m-%d)
---

# $(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1')

${DESCRIPTION}

## Usage

TODO: Add usage instructions

## Features

TODO: List key features

## Examples

TODO: Add examples

## Notes

TODO: Add any important notes or limitations
EOF

echo -e "${GREEN}✓ Generated SKILL.md${NC}"

# Create README.md
cat > "$SKILL_DIR/README.md" <<EOF
# ${SKILL_NAME}

${DESCRIPTION}

## Installation

\`\`\`bash
# Copy this skill to your skills directory
cp -r ${SKILL_NAME} ~/.your-agent/skills/
\`\`\`

## Usage

See [SKILL.md](SKILL.md) for detailed instructions.

## License

MIT
EOF

echo -e "${GREEN}✓ Generated README.md${NC}"

# Create example script if requested
if [[ "$WITH_SCRIPTS" == true ]]; then
  cat > "$SKILL_DIR/scripts/example.sh" <<'EOFSCRIPT'
#!/usr/bin/env bash
set -euo pipefail

# Example script - replace with actual implementation

echo "Hello from ${SKILL_NAME}!"
EOFSCRIPT
  
  chmod +x "$SKILL_DIR/scripts/example.sh"
  echo -e "${GREEN}✓ Created example script${NC}"
fi

# Create reference files if requested
if [[ "$WITH_REFERENCES" == true ]]; then
  cat > "$SKILL_DIR/references/REFERENCE.md" <<EOFREF
# ${SKILL_NAME} Reference

Detailed technical reference for the ${SKILL_NAME} skill.

## API Reference

TODO: Add API reference

## Configuration

TODO: Add configuration options

## Advanced Usage

TODO: Add advanced usage examples
EOFREF
  
  echo -e "${GREEN}✓ Created reference documentation${NC}"
fi

# Validate the created skill
echo -e "${YELLOW}Validating skill structure...${NC}"

# Check SKILL.md has valid frontmatter
if head -n 1 "$SKILL_DIR/SKILL.md" | grep -q "^---$"; then
  echo -e "${GREEN}✓ SKILL.md has valid YAML frontmatter${NC}"
else
  echo -e "${RED}✗ SKILL.md frontmatter validation failed${NC}"
fi

# Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ Skill created successfully!${NC}"
echo -e "${BLUE}Location:${NC} ${SKILL_DIR}"
echo -e "${BLUE}Name:${NC} ${SKILL_NAME}"
echo -e "${BLUE}Description:${NC} ${DESCRIPTION}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Edit ${SKILL_NAME}/SKILL.md to add detailed instructions"
echo -e "  2. Add scripts to ${SKILL_NAME}/scripts/ if needed"
echo -e "  3. Test the skill in your agent environment"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
