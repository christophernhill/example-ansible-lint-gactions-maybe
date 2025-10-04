#!/bin/bash
# Replication status monitoring script
# Checks if storage replication is working correctly

set -euo pipefail

# Configuration
REPLICATION_STATUS_FILE="/var/run/replication.status"
LOG_FILE="/var/log/replication_monitor.log"
MAX_LAG_SECONDS=300

# Function to check replication lag
check_replication_lag() {
    if [ ! -f "$REPLICATION_STATUS_FILE" ]; then
        echo "ERROR: Replication status file not found" | tee -a "$LOG_FILE"
        return 2
    fi

    last_sync=$(cat "$REPLICATION_STATUS_FILE")
    current_time=$(date +%s)
    lag=$((current_time - last_sync))

    echo "$(date '+%Y-%m-%d %H:%M:%S') - Replication lag: ${lag} seconds" >> "$LOG_FILE"

    if [ "$lag" -gt "$MAX_LAG_SECONDS" ]; then
        echo "WARNING: Replication lag is ${lag} seconds (max: ${MAX_LAG_SECONDS})" | tee -a "$LOG_FILE"
        return 1
    else
        echo "OK: Replication lag is ${lag} seconds" | tee -a "$LOG_FILE"
        return 0
    fi
}

# Main execution
check_replication_lag
exit $?

