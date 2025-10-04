#!/bin/bash
# Alert sending script
# Sends alerts via multiple channels (email, webhook, etc.)

set -euo pipefail

# Configuration
ALERT_EMAIL="${ALERT_EMAIL:-alerts@example.com}"
WEBHOOK_URL="${WEBHOOK_URL:-https://hooks.example.com/alerts}"
LOG_FILE="/var/log/alerts.log"

# Parse arguments
SEVERITY="${1:-INFO}"
MESSAGE="${2:-No message provided}"
SOURCE="${3:-$(hostname)}"

# Function to send email alert
send_email_alert() {
    echo "$MESSAGE" | mail -s "[$SEVERITY] Alert from $SOURCE" "$ALERT_EMAIL"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Email alert sent: $MESSAGE" >> "$LOG_FILE"
}

# Function to send webhook alert
send_webhook_alert() {
    curl -X POST "$WEBHOOK_URL" \
        -H "Content-Type: application/json" \
        -d "{\"severity\": \"$SEVERITY\", \"message\": \"$MESSAGE\", \"source\": \"$SOURCE\"}" \
        >> "$LOG_FILE" 2>&1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Webhook alert sent: $MESSAGE" >> "$LOG_FILE"
}

# Main execution
echo "$(date '+%Y-%m-%d %H:%M:%S') - Sending alert: [$SEVERITY] $MESSAGE from $SOURCE" | tee -a "$LOG_FILE"

# Send alerts
send_email_alert
send_webhook_alert

exit 0

