#!/bin/bash
# Slack API Helper - Search Messages
# Usage: bash slack-search.sh "search query" [COUNT]

SLACK_TOKEN=$(cat ~/.openclaw/secrets/slack-token)
QUERY="${1}"
COUNT="${2:-10}"

if [ -z "$QUERY" ]; then
  echo "Usage: bash slack-search.sh \"search query\" [COUNT]"
  echo ""
  echo "Examples:"
  echo "  bash slack-search.sh \"from:me\" 20"
  echo "  bash slack-search.sh \"in:#dev bug\" 10"
  echo "  bash slack-search.sh \"has:link after:2026-03-20\""
  exit 1
fi

echo "🔍 Searching: $QUERY (limit: $COUNT)"
echo ""

curl -s -H "Authorization: Bearer $SLACK_TOKEN" \
  "https://slack.com/api/search.messages?query=$(echo "$QUERY" | jq -sRr @uri)&count=$COUNT" \
  | jq -r '.messages.matches[]? | "[\(.channel.name)] \(.username): \(.text[0:150])"'
