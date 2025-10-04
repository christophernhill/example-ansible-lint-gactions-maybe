#!/bin/bash
# Storage reporting script
# Generates daily/weekly reports on storage usage and health

set -euo pipefail

# Configuration
REPORT_DIR="/var/reports/storage"
REPORT_FILE="${REPORT_DIR}/storage_report_$(date +%Y%m%d).txt"
STORAGE_SERVERS="storage-01 storage-02 storage-03"

# Create report directory
mkdir -p "${REPORT_DIR}"

# Start report
{
    echo "=================================="
    echo "Storage System Report"
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "=================================="
    echo ""

    # Check each storage server
    for server in ${STORAGE_SERVERS}; do
        echo "Server: ${server}"
        echo "----------------------------------"
        
        # Disk usage
        echo "Disk Usage:"
        ssh "${server}" "df -h /mnt/storage" || echo "ERROR: Could not connect to ${server}"
        echo ""
        
        # Inode usage
        echo "Inode Usage:"
        ssh "${server}" "df -i /mnt/storage" || echo "ERROR: Could not get inode info"
        echo ""
        
        # Recent errors
        echo "Recent Errors (last 24h):"
        ssh "${server}" "journalctl --since '24 hours ago' --priority=err" || echo "No errors found"
        echo ""
        echo ""
    done

    echo "=================================="
    echo "Report Complete"
    echo "=================================="
} > "${REPORT_FILE}"

echo "Report generated: ${REPORT_FILE}"
exit 0

