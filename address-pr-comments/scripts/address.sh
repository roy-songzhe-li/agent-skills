#!/usr/bin/env bash
set -euo pipefail

# Address PR Comments Automation Script
# Usage: bash address.sh <owner/repo> <pr-number> [--new-only] [--comment-id <id>]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
API_MODEL="${API_MODEL:-anthropic/claude-sonnet-4-5}"
API_BASE_URL="${API_BASE_URL:-http://localhost:11434/v1}"
API_KEY="${API_KEY:-dummy}"

STATE_FILE="${SCRIPT_DIR}/.addressed-comments.json"

# Parse arguments
if [[ $# -lt 2 ]]; then
  echo -e "${RED}Usage: bash address.sh <owner/repo> <pr-number> [--new-only] [--comment-id <id>]${NC}"
  echo "Example: bash address.sh aetheron/api 123"
  exit 1
fi

REPO="$1"
PR_NUMBER="$2"
NEW_ONLY=false
SPECIFIC_COMMENT=""

shift 2
while [[ $# -gt 0 ]]; do
  case $1 in
    --new-only)
      NEW_ONLY=true
      shift
      ;;
    --comment-id)
      SPECIFIC_COMMENT="$2"
      shift 2
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

# Validate gh CLI
if ! command -v gh &> /dev/null; then
  echo -e "${RED}Error: gh CLI is not installed${NC}"
  exit 1
fi

if ! gh auth status &> /dev/null; then
  echo -e "${RED}Error: gh CLI is not authenticated${NC}"
  exit 1
fi

echo -e "${BLUE}💬 Addressing PR #${PR_NUMBER} in ${REPO}${NC}"

# Initialize state file
if [[ ! -f "${STATE_FILE}" ]]; then
  echo '{}' > "${STATE_FILE}"
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "${TEMP_DIR}"' EXIT

COMMENTS_FILE="${TEMP_DIR}/comments.json"

# Fetch PR review comments
echo -e "${YELLOW}⟳ Fetching PR review comments...${NC}"
gh api \
  -H "Accept: application/vnd.github+json" \
  "/repos/${REPO}/pulls/${PR_NUMBER}/comments" \
  > "${COMMENTS_FILE}"

TOTAL_COMMENTS=$(jq 'length' "${COMMENTS_FILE}")
echo -e "${GREEN}✓ Found ${TOTAL_COMMENTS} review comments${NC}"

if [[ "${TOTAL_COMMENTS}" -eq 0 ]]; then
  echo -e "${YELLOW}No comments to address${NC}"
  exit 0
fi

# Filter comments
if [[ -n "${SPECIFIC_COMMENT}" ]]; then
  echo -e "${YELLOW}⟳ Filtering to comment #${SPECIFIC_COMMENT}...${NC}"
  jq "[.[] | select(.id == ${SPECIFIC_COMMENT})]" "${COMMENTS_FILE}" > "${TEMP_DIR}/filtered.json"
  mv "${TEMP_DIR}/filtered.json" "${COMMENTS_FILE}"
  TOTAL_COMMENTS=$(jq 'length' "${COMMENTS_FILE}")
fi

# Load state
PR_KEY="pr_${PR_NUMBER}"
ADDRESSED_IDS=$(jq -r ".${PR_KEY} // {} | keys[]" "${STATE_FILE}" 2>/dev/null || echo "")

# Process each comment
PROCESSED=0
FIXED=0
SKIPPED=0

for i in $(seq 0 $((TOTAL_COMMENTS - 1))); do
  COMMENT=$(jq -c ".[$i]" "${COMMENTS_FILE}")
  COMMENT_ID=$(echo "${COMMENT}" | jq -r '.id')
  COMMENT_BODY=$(echo "${COMMENT}" | jq -r '.body')
  COMMENT_PATH=$(echo "${COMMENT}" | jq -r '.path')
  COMMENT_LINE=$(echo "${COMMENT}" | jq -r '.line // .original_line')
  COMMENT_USER=$(echo "${COMMENT}" | jq -r '.user.login')
  
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}Comment #${COMMENT_ID} by @${COMMENT_USER}${NC}"
  echo -e "${BLUE}File: ${COMMENT_PATH}:${COMMENT_LINE}${NC}"
  echo -e "${YELLOW}\"${COMMENT_BODY}\"${NC}"
  
  # Check if already addressed
  if echo "${ADDRESSED_IDS}" | grep -q "^comment_${COMMENT_ID}$"; then
    if [[ "${NEW_ONLY}" == true ]]; then
      echo -e "${YELLOW}⊘ Already addressed, skipping${NC}"
      ((SKIPPED++))
      continue
    fi
  fi
  
  # Verify if comment is valid
  echo -e "${YELLOW}⟳ Verifying comment...${NC}"
  
  # Prepare verification prompt
  VERIFY_PROMPT=$(cat <<EOF
You are a code review assistant. A team member or AI agent has left a review comment on a PR.
Your task is to determine if this comment represents a REAL issue that should be addressed.

**Comment:**
${COMMENT_BODY}

**File:** ${COMMENT_PATH}
**Line:** ${COMMENT_LINE}

**Determine:**
1. Is this a valid issue that needs to be fixed?
2. Is it within the scope of this PR?
3. Is it technically feasible to fix?

**Output JSON:**
{
  "valid": true/false,
  "reason": "brief explanation (one sentence)",
  "priority": "blocker|major|minor|nitpick",
  "suggested_fix": "brief description of how to fix it (if valid)"
}

If NOT valid, provide a polite reason:
- "This is outside the scope of this PR"
- "This was already addressed in commit abc123"
- "The current implementation is intentional because..."
- "Could you clarify your concern? I think..."

Use tentative, polite language. Avoid dashes.
EOF
)
  
  # Call LLM to verify
  VERIFY_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${API_KEY}" \
    -d @- <<EOF_JSON
{
  "model": "${API_MODEL}",
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful code review assistant. Analyze review comments and determine if they are valid issues."
    },
    {
      "role": "user",
      "content": $(echo "${VERIFY_PROMPT}" | jq -Rs .)
    }
  ],
  "temperature": 0.3,
  "max_tokens": 500
}
EOF_JSON
)
  
  # Extract verification result
  VERIFY_JSON=$(echo "${VERIFY_RESPONSE}" | jq -r '.choices[0].message.content' | jq -c .)
  
  if ! echo "${VERIFY_JSON}" | jq empty 2>/dev/null; then
    echo -e "${RED}Error: Invalid JSON response from LLM${NC}"
    echo "${VERIFY_JSON}"
    continue
  fi
  
  IS_VALID=$(echo "${VERIFY_JSON}" | jq -r '.valid')
  REASON=$(echo "${VERIFY_JSON}" | jq -r '.reason')
  PRIORITY=$(echo "${VERIFY_JSON}" | jq -r '.priority // "minor"')
  
  if [[ "${IS_VALID}" == "true" ]]; then
    echo -e "${GREEN}✓ Valid issue (${PRIORITY})${NC}"
    echo -e "${BLUE}Reason: ${REASON}${NC}"
    
    # Generate fix
    echo -e "${YELLOW}⟳ Generating fix...${NC}"
    
    # Get current file content
    FILE_CONTENT=$(cat "${COMMENT_PATH}" 2>/dev/null || echo "")
    
    if [[ -z "${FILE_CONTENT}" ]]; then
      echo -e "${RED}Error: Cannot read file ${COMMENT_PATH}${NC}"
      continue
    fi
    
    FIX_PROMPT=$(cat <<EOF
You are a code fix assistant. Generate a fix for the following review comment.

**Comment:**
${COMMENT_BODY}

**File:** ${COMMENT_PATH}
**Line:** ${COMMENT_LINE}

**Current file content:**
\`\`\`
${FILE_CONTENT}
\`\`\`

**Task:**
1. Generate the exact code changes needed to fix this issue
2. Provide a brief, one-sentence description of the fix (no dashes)

**Output JSON:**
{
  "description": "one sentence describing the fix (will be used in commit message and reply)",
  "changes": [
    {
      "type": "replace|insert|delete",
      "old_code": "code to replace (if type=replace)",
      "new_code": "new code",
      "line": line_number
    }
  ]
}

Example description format: "findLambda now constructs the exact expected name instead of using includes()"
Use English, avoid dashes, be concise.
EOF
)
    
    FIX_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/chat/completions" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer ${API_KEY}" \
      -d @- <<EOF_JSON2
{
  "model": "${API_MODEL}",
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful code fix assistant. Generate precise code changes to address review comments."
    },
    {
      "role": "user",
      "content": $(echo "${FIX_PROMPT}" | jq -Rs .)
    }
  ],
  "temperature": 0.3,
  "max_tokens": 2000
}
EOF_JSON2
)
    
    FIX_JSON=$(echo "${FIX_RESPONSE}" | jq -r '.choices[0].message.content' | jq -c .)
    
    if ! echo "${FIX_JSON}" | jq empty 2>/dev/null; then
      echo -e "${RED}Error: Invalid fix JSON${NC}"
      continue
    fi
    
    FIX_DESC=$(echo "${FIX_JSON}" | jq -r '.description')
    
    echo -e "${GREEN}✓ Generated fix: ${FIX_DESC}${NC}"
    
    # Apply fix (simplified - in real use, you'd parse and apply changes)
    echo -e "${YELLOW}⊠ Fix generation complete (manual application needed)${NC}"
    echo -e "${YELLOW}Please review and apply the suggested changes, then commit.${NC}"
    
    # For now, skip auto-commit and just prepare the reply
    echo -e "${YELLOW}After committing, the script will reply to the comment.${NC}"
    
    # Prompt user for commit hash
    read -p "Enter commit hash (or 'skip' to skip this comment): " COMMIT_HASH
    
    if [[ "${COMMIT_HASH}" == "skip" ]]; then
      echo -e "${YELLOW}⊘ Skipped${NC}"
      continue
    fi
    
    # Reply to comment
    REPLY_BODY="Fixed in ${COMMIT_HASH}: ${FIX_DESC}"
    
    echo -e "${YELLOW}⟳ Replying to comment...${NC}"
    echo -e "${BLUE}Reply: ${REPLY_BODY}${NC}"
    
    gh api \
      --method POST \
      -H "Accept: application/vnd.github+json" \
      "/repos/${REPO}/pulls/${PR_NUMBER}/comments/${COMMENT_ID}/replies" \
      -f body="${REPLY_BODY}" \
      > /dev/null
    
    echo -e "${GREEN}✓ Replied to comment${NC}"
    
    # Update state
    jq ".${PR_KEY}.comment_${COMMENT_ID} = {\"status\": \"fixed\", \"commit\": \"${COMMIT_HASH}\", \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" \
      "${STATE_FILE}" > "${TEMP_DIR}/state.json"
    mv "${TEMP_DIR}/state.json" "${STATE_FILE}"
    
    ((FIXED++))
    
  else
    echo -e "${YELLOW}⊘ Not a valid issue${NC}"
    echo -e "${BLUE}Reason: ${REASON}${NC}"
    
    # Reply to comment explaining why
    REPLY_BODY="${REASON}"
    
    echo -e "${YELLOW}⟳ Replying to comment...${NC}"
    echo -e "${BLUE}Reply: ${REPLY_BODY}${NC}"
    
    gh api \
      --method POST \
      -H "Accept: application/vnd.github+json" \
      "/repos/${REPO}/pulls/${PR_NUMBER}/comments/${COMMENT_ID}/replies" \
      -f body="${REPLY_BODY}" \
      > /dev/null
    
    echo -e "${GREEN}✓ Replied to comment${NC}"
    
    # Update state
    jq ".${PR_KEY}.comment_${COMMENT_ID} = {\"status\": \"invalid\", \"reason\": \"${REASON}\", \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" \
      "${STATE_FILE}" > "${TEMP_DIR}/state.json"
    mv "${TEMP_DIR}/state.json" "${STATE_FILE}"
  fi
  
  ((PROCESSED++))
done

# Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ Processed ${PROCESSED} comments${NC}"
echo -e "${BLUE}Fixed:${NC} ${FIXED}"
echo -e "${BLUE}Skipped:${NC} ${SKIPPED}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Show PR URL
PR_URL=$(gh pr view "${PR_NUMBER}" --repo "${REPO}" --json url --jq '.url')
echo -e "${BLUE}View PR:${NC} ${PR_URL}"
