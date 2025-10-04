#!/bin/bash
# Script to install Git hooks for local linting

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Installing Git Hooks${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if we're in a git repository
if [[ ! -d ".git" ]]; then
    echo -e "${YELLOW}Error: Not in a git repository root directory${NC}"
    echo "Please run this script from the repository root"
    exit 1
fi

# Create .git/hooks directory if it doesn't exist
mkdir -p .git/hooks

# Copy pre-commit hook
if [[ -f "pre-commit" ]]; then
    echo "Installing pre-commit hook..."
    cp pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo -e "${GREEN}✓ Pre-commit hook installed${NC}"
else
    echo -e "${YELLOW}Warning: pre-commit file not found${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Git hooks installed successfully!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "The pre-commit hook will now run automatically before each commit."
echo ""
echo "What it checks:"
echo "  ✓ YAML syntax and formatting (yamllint)"
echo "  ✓ Ansible best practices (ansible-lint)"
echo "  ✓ Ansible playbook syntax (ansible-playbook --syntax-check)"
echo "  ✓ Shell script errors (shellcheck)"
echo "  ✓ Trailing whitespace"
echo "  ✓ Potential secrets in code"
echo ""
echo "To bypass the hook (not recommended):"
echo "  git commit --no-verify"
echo ""
echo "To check which tools are available:"
echo "  Try making a commit and the hook will report which tools it found"
echo ""

