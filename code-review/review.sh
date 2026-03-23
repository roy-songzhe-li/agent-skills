#!/usr/bin/env bash
set -euo pipefail

# Code Review Automation Script
# Usage: bash review.sh <owner/repo> <pr-number> [--dry-run]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
API_MODEL="${API_MODEL:-anthropic/claude-sonnet-4-5}"
API_BASE_URL="${API_BASE_URL:-http://localhost:11434/v1}" # Default to Ollama
API_KEY="${API_KEY:-dummy}" # Ollama doesn't need a key

# Parse arguments
if [[ $# -lt 2 ]]; then
  echo -e "${RED}Usage: bash review.sh <owner/repo> <pr-number> [--dry-run]${NC}"
  echo "Example: bash review.sh aetheron/api 123"
  exit 1
fi

REPO="$1"
PR_NUMBER="$2"
DRY_RUN=false

if [[ "${3:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo -e "${YELLOW}🔍 Dry run mode - will not post comments${NC}"
fi

# Validate gh CLI
if ! command -v gh &> /dev/null; then
  echo -e "${RED}Error: gh CLI is not installed${NC}"
  echo "Install it with: brew install gh"
  exit 1
fi

# Check gh auth
if ! gh auth status &> /dev/null; then
  echo -e "${RED}Error: gh CLI is not authenticated${NC}"
  echo "Run: gh auth login"
  exit 1
fi

echo -e "${BLUE}📋 Reviewing PR #${PR_NUMBER} in ${REPO}${NC}"

# Create temp directory
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "${TEMP_DIR}"' EXIT

DIFF_FILE="${TEMP_DIR}/pr.diff"
REVIEW_FILE="${TEMP_DIR}/review.json"
PROMPT_FILE="${TEMP_DIR}/prompt.txt"

# Fetch PR diff
echo -e "${YELLOW}⟳ Fetching PR diff...${NC}"
gh pr diff "${PR_NUMBER}" --repo "${REPO}" > "${DIFF_FILE}"

if [[ ! -s "${DIFF_FILE}" ]]; then
  echo -e "${RED}Error: No diff found for PR #${PR_NUMBER}${NC}"
  exit 1
fi

echo -e "${GREEN}✓ Fetched $(wc -l < "${DIFF_FILE}") lines of diff${NC}"

# Read project architecture rules from AGENTS.md
echo -e "${YELLOW}⟳ Reading project architecture rules...${NC}"
AGENTS_FILE="${TEMP_DIR}/AGENTS.md"
gh api "/repos/${REPO}/contents/AGENTS.md" --jq '.content' 2>/dev/null | base64 -d > "${AGENTS_FILE}" || echo "" > "${AGENTS_FILE}"

if [[ -s "${AGENTS_FILE}" ]]; then
  echo -e "${GREEN}✓ Found AGENTS.md with $(wc -l < "${AGENTS_FILE}") lines${NC}"
else
  echo -e "${YELLOW}⊘ No AGENTS.md found, using general best practices${NC}"
fi

# Check if there are already comments to avoid duplicates
echo -e "${YELLOW}⟳ Checking existing review comments...${NC}"
EXISTING_COMMENTS=$(gh api "/repos/${REPO}/pulls/${PR_NUMBER}/comments" --jq '.[].body' 2>/dev/null || echo "")

# Prepare prompt
echo -e "${YELLOW}⟳ Preparing review prompt...${NC}"
PROMPT_TEMPLATE="${SCRIPT_DIR}/review-prompt.txt"

if [[ ! -f "${PROMPT_TEMPLATE}" ]]; then
  echo -e "${RED}Error: review-prompt.txt not found${NC}"
  exit 1
fi

# Read AGENTS.md content
AGENTS_RULES="No project-specific architecture rules found."
if [[ -s "${AGENTS_FILE}" ]]; then
  AGENTS_RULES=$(cat "${AGENTS_FILE}")
fi

# Replace placeholders
cat "${PROMPT_TEMPLATE}" | \
  sed "s|{AGENTS_RULES}|${AGENTS_RULES}|g" | \
  sed "s|{DIFF_CONTENT}|$(cat "${DIFF_FILE}")|g" \
  > "${PROMPT_FILE}"

# Call LLM API
echo -e "${YELLOW}⟳ Analyzing code with LLM...${NC}"

# Use curl to call OpenAI-compatible API
REVIEW_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${API_KEY}" \
  -d @- <<EOF
{
  "model": "${API_MODEL}",
  "messages": [
    {
      "role": "system",
      "content": "You are an expert code reviewer. Analyze the provided PR diff and generate structured review comments in JSON format."
    },
    {
      "role": "user",
      "content": $(jq -Rs . < "${PROMPT_FILE}")
    }
  ],
  "temperature": 0.3,
  "max_tokens": 4000
}
EOF
)

# Extract JSON from response
echo "${REVIEW_RESPONSE}" | jq -r '.choices[0].message.content' > "${REVIEW_FILE}"

# Parse review
if ! jq empty "${REVIEW_FILE}" 2>/dev/null; then
  echo -e "${RED}Error: Invalid JSON response from LLM${NC}"
  echo "Response:"
  cat "${REVIEW_FILE}"
  exit 1
fi

STATUS=$(jq -r '.status // "COMMENT"' "${REVIEW_FILE}")
SUMMARY=$(jq -r '.summary // "Review complete"' "${REVIEW_FILE}")
COMMENT_COUNT=$(jq -r '.comments | length' "${REVIEW_FILE}")

echo -e "${GREEN}✓ Review complete: ${COMMENT_COUNT} comments, status: ${STATUS}${NC}"

# Post inline comments
if [[ "${COMMENT_COUNT}" -gt 0 ]]; then
  echo -e "${YELLOW}⟳ Posting inline comments...${NC}"
  
  # Build comments array for GitHub API
  COMMENTS_JSON=$(jq -c '.comments | map({
    path: .file,
    line: .line,
    body: "\(.category): \(.comment)"
  })' "${REVIEW_FILE}")
  
  if [[ "${DRY_RUN}" == true ]]; then
    echo -e "${YELLOW}[DRY RUN] Would post ${COMMENT_COUNT} comments:${NC}"
    echo "${COMMENTS_JSON}" | jq .
  else
    # Check for duplicates
    FILTERED_COMMENTS="[]"
    for comment in $(echo "${COMMENTS_JSON}" | jq -c '.[]'); do
      COMMENT_BODY=$(echo "${comment}" | jq -r '.body')
      if ! echo "${EXISTING_COMMENTS}" | grep -qF "${COMMENT_BODY}"; then
        FILTERED_COMMENTS=$(echo "${FILTERED_COMMENTS}" | jq ". + [${comment}]")
      else
        echo -e "${YELLOW}⊘ Skipping duplicate: ${COMMENT_BODY}${NC}"
      fi
    done
    
    NEW_COMMENT_COUNT=$(echo "${FILTERED_COMMENTS}" | jq 'length')
    
    if [[ "${NEW_COMMENT_COUNT}" -gt 0 ]]; then
      # Post review with inline comments
      gh api \
        --method POST \
        -H "Accept: application/vnd.github+json" \
        "/repos/${REPO}/pulls/${PR_NUMBER}/reviews" \
        -f body="${SUMMARY}" \
        -f event="${STATUS}" \
        -f comments="$(echo "${FILTERED_COMMENTS}" | jq -c .)" \
        > /dev/null
      
      echo -e "${GREEN}✓ Posted ${NEW_COMMENT_COUNT} inline comments${NC}"
    else
      echo -e "${YELLOW}⊘ All comments were duplicates, skipping${NC}"
    fi
  fi
else
  # No comments, just post summary
  echo -e "${YELLOW}⟳ No comments to post, submitting ${STATUS}...${NC}"
  
  if [[ "${DRY_RUN}" == true ]]; then
    echo -e "${YELLOW}[DRY RUN] Would post: ${STATUS} - ${SUMMARY}${NC}"
  else
    gh api \
      --method POST \
      -H "Accept: application/vnd.github+json" \
      "/repos/${REPO}/pulls/${PR_NUMBER}/reviews" \
      -f body="${SUMMARY}" \
      -f event="${STATUS}" \
      > /dev/null
    
    echo -e "${GREEN}✓ Submitted ${STATUS}${NC}"
  fi
fi

# Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ Review complete for PR #${PR_NUMBER}${NC}"
echo -e "${BLUE}Status:${NC} ${STATUS}"
echo -e "${BLUE}Summary:${NC} ${SUMMARY}"
echo -e "${BLUE}Comments:${NC} ${COMMENT_COUNT}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Show PR URL
PR_URL=$(gh pr view "${PR_NUMBER}" --repo "${REPO}" --json url --jq '.url')
echo -e "${BLUE}View PR:${NC} ${PR_URL}"
