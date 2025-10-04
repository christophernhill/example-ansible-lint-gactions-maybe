#!/bin/bash
# Storage monitoring script
# Checks disk usage and alerts if thresholds are exceeded

set -euo pipefail

# Configuration
THRESHOLD_WARNING=80
THRESHOLD_CRITICAL=90
MOUNT_POINT="/mnt/storage"
LOG_FILE="/var/log/storage_monitor.log"

# Get current disk usage percentage
usage=$(df -h "$MOUNT_POINT" | awk 'NR==2 {print $5}' | sed 's/%//')

# Log the check
echo "$(date '+%Y-%m-%d %H:%M:%S') - Storage usage: ${usage}%" >> "$LOG_FILE"

# Check thresholds
if [ "$usage" -ge "$THRESHOLD_CRITICAL" ]; then
    echo "CRITICAL: Storage usage at ${usage}% (threshold: ${THRESHOLD_CRITICAL}%)" | tee -a "$LOG_FILE"
    exit 2
elif [ "$usage" -ge "$THRESHOLD_WARNING" ]; then
    echo "WARNING: Storage usage at ${usage}% (threshold: ${THRESHOLD_WARNING}%)" | tee -a "$LOG_FILE"
    exit 1
else
    echo "OK: Storage usage at ${usage}%" | tee -a "$LOG_FILE"
    exit 0
fi

