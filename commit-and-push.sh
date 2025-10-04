#!/bin/bash
# Script to commit and push all new Ansible linting files

set -euo pipefail

echo "=================================================="
echo "Committing Ansible Linting Setup"
echo "=================================================="
echo ""

# Add all files
echo "Step 1: Adding all files..."
git add .

echo ""
echo "Step 2: Creating commit..."
git commit -m "Add Ansible linting setup with GitHub Actions

This commit adds comprehensive linting infrastructure for Ansible-based
storage server management:

Added:
- GitHub Actions workflows (CI, security scanning, testing)
- Linting configuration (ansible-lint, yamllint, shellcheck, bandit)
- Ansible project structure (inventory, playbooks, roles)
- Example playbooks (provisioning, monitoring)
- Operational scripts (monitoring, alerting, reporting, provisioning)
- Comprehensive documentation (README, QUICKSTART, LINTING_RULES)

Features:
- Automated linting on push/PR
- Multi-version Ansible testing (2.14, 2.15, 2.16)
- Security scanning (bandit, checkov, secrets detection)
- Shell script analysis
- YAML validation

The repository is now ready for storage server management with
automated code quality checks."

echo ""
echo "Step 3: Pushing to GitHub..."
git push origin main

echo ""
echo "=================================================="
echo "✅ Successfully pushed to GitHub!"
echo "=================================================="
echo ""
echo "View your repository at:"
git remote get-url origin | sed 's/\.git$//'
echo ""
echo "Check the Actions tab to see workflows running!"
echo ""

