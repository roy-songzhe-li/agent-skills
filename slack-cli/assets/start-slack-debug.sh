#!/bin/bash

# Start Slack with CDP debugging enabled
# Usage: bash start-slack-debug.sh

set -e

echo "🔧 Starting Slack with CDP debugging..."

# Kill existing Slack process
pkill -9 Slack 2>/dev/null || true
sleep 1

# Start Slack with remote debugging port
/Applications/Slack.app/Contents/MacOS/Slack --remote-debugging-port=9233 &

echo "✅ Slack started with CDP on port 9233"
echo "📍 CDP endpoint: http://127.0.0.1:9233"
echo ""
echo "Verify connection:"
echo "  open http://127.0.0.1:9233"
echo ""
echo "Set environment variable:"
echo "  export OPENCLI_CDP_ENDPOINT='http://127.0.0.1:9233'"
echo ""
echo "Test commands:"
echo "  opencli slack-app status"
echo "  opencli slack-app read --count 10"
