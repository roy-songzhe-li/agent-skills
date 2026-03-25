#!/bin/bash
# Slack API Helper - List Channels
# Usage: bash slack-channels.sh

SLACK_TOKEN=$(cat ~/.openclaw/secrets/slack-token)

echo "📋 Listing all channels..."
echo ""

curl -s -H "Authorization: Bearer $SLACK_TOKEN" \
  'https://slack.com/api/conversations.list?types=public_channel,private_channel&limit=100' \
  | jq -r '.channels[] | "\(.name) (\(.id)) - \(.num_members) members \(if .is_private then "[Private]" else "" end)"'
