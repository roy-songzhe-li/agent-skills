#!/bin/bash
# Slack API Helper - Read Messages
# Usage: bash slack-read.sh [CHANNEL_ID] [LIMIT]

SLACK_TOKEN=$(cat ~/.openclaw/secrets/slack-token)
CHANNEL="${1:-C079AKFJLTX}"  # Default: #dev
LIMIT="${2:-20}"

echo "📖 Reading $LIMIT messages from channel $CHANNEL..."
echo ""

curl -s -H "Authorization: Bearer $SLACK_TOKEN" \
  "https://slack.com/api/conversations.history?channel=$CHANNEL&limit=$LIMIT" \
  | jq -r '.messages[] | "[\(.ts | tonumber | strftime("%Y-%m-%d %H:%M"))] \(.user // "system"): \(.text[0:200])"'
