#!/bin/bash
# Slack API Helper - Send Message
# Usage: bash slack-send.sh [CHANNEL_ID] "message text"

SLACK_TOKEN=$(cat ~/.openclaw/secrets/slack-token)
CHANNEL="${1}"
MESSAGE="${2}"

if [ -z "$CHANNEL" ] || [ -z "$MESSAGE" ]; then
  echo "Usage: bash slack-send.sh [CHANNEL_ID] \"message text\""
  echo ""
  echo "Examples:"
  echo "  bash slack-send.sh U08MNQZGHBP \"Hello Roy\""
  echo "  bash slack-send.sh C079AKFJLTX \"Message to #dev\""
  exit 1
fi

echo "📤 Sending message to $CHANNEL..."
echo ""

curl -X POST -H "Authorization: Bearer $SLACK_TOKEN" \
  -H "Content-Type: application/json" \
  'https://slack.com/api/chat.postMessage' \
  -d "{\"channel\":\"$CHANNEL\",\"text\":$(echo "$MESSAGE" | jq -Rs .)}" \
  | jq '{ok, ts, channel}'
