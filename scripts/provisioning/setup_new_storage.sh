#!/bin/bash
# Storage server provisioning script
# Automates the initial setup of new storage servers

set -euo pipefail

# Configuration
NEW_SERVER="${1:-}"
ANSIBLE_INVENTORY="${2:-inventory/hosts.ini}"

# Validate input
if [[ -z "${NEW_SERVER}" ]]; then
    echo "Usage: $0 <server_hostname> [inventory_file]"
    exit 1
fi

echo "Provisioning new storage server: ${NEW_SERVER}"
echo "Using inventory: ${ANSIBLE_INVENTORY}"

# Run Ansible provisioning playbook
ansible-playbook -i "${ANSIBLE_INVENTORY}" \
    --limit "${NEW_SERVER}" \
    playbooks/provision_storage.yml

# Verify the setup
echo "Verifying server setup..."
ansible "${NEW_SERVER}" -i "${ANSIBLE_INVENTORY}" \
    -m shell -a "df -h /mnt/storage && systemctl status storage-monitor"

echo "Provisioning complete for ${NEW_SERVER}"
exit 0

