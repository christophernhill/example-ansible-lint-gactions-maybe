# Git Hooks for Local Linting

This repository includes a pre-commit Git hook that automatically runs linting checks on your code before allowing a commit. This helps catch issues early, before they're pushed to GitHub.

## 🚀 Installation

Run the installation script from the repository root:

```bash
./install-git-hooks.sh
```

This will copy the `pre-commit` hook to `.git/hooks/pre-commit` and make it executable.

## ✅ What Gets Checked

When you run `git commit`, the hook automatically checks:

### 1. YAML Files
- **Tool**: `yamllint`
- **Checks**: Syntax, formatting, indentation, line length
- **Files**: All `.yml` and `.yaml` files

### 2. Ansible Files
- **Tool**: `ansible-lint`
- **Checks**: Best practices, task naming, deprecated modules
- **Files**: YAML files in `playbooks/`, `roles/`, `inventory/`

### 3. Ansible Syntax
- **Tool**: `ansible-playbook --syntax-check`
- **Checks**: Playbook syntax validation
- **Files**: Playbooks in `playbooks/` directory

### 4. Shell Scripts
- **Tool**: `shellcheck`
- **Checks**: Common bash errors, best practices
- **Files**: All `.sh` files

### 5. Common Issues
- Trailing whitespace
- TODO/FIXME comments (warning)
- Potential hardcoded secrets (error)

## 📋 Requirements

The hook checks which tools are available and skips checks for missing tools:

**Required tools:**
```bash
# Install with pip
pip install ansible-lint yamllint

# Install shellcheck
# macOS:
brew install shellcheck

# Ubuntu/Debian:
sudo apt-get install shellcheck

# Or via snap:
sudo snap install shellcheck
```

## 🎯 Usage

### Normal Commit
Simply commit as usual:
```bash
git add .
git commit -m "Your commit message"
```

The hook will run automatically and:
- ✅ **Allow the commit** if all checks pass
- ❌ **Block the commit** if any checks fail

### Example Output

**When checks pass:**
```
========================================
Running Pre-Commit Linting Checks
========================================

>>> Checking for required tools...
✓ ansible-lint found
✓ yamllint found
✓ shellcheck found

>>> Linting YAML files...
✓ YAML linting passed

>>> Linting Ansible files...
✓ Ansible linting passed

>>> Checking for common issues...
✓ No trailing whitespace found

========================================
All linting checks passed! ✓
========================================
```

**When checks fail:**
```
========================================
Running Pre-Commit Linting Checks
========================================

>>> Linting YAML files...
playbooks/example.yml:10:1 [empty-lines] too many blank lines (2 > 1)
✗ YAML linting failed

========================================
Linting checks failed! ✗
========================================

To skip these checks (not recommended), use:
  git commit --no-verify

To fix the issues:
  1. Review the errors above
  2. Fix the issues in your files
  3. Stage the fixed files: git add <files>
  4. Try committing again
```

## 🔓 Bypassing the Hook

**Not recommended**, but if you need to bypass the checks:

```bash
git commit --no-verify -m "Your message"
# or
git commit -n -m "Your message"
```

⚠️ **Warning**: Bypassing the hook means your code won't be checked until GitHub Actions runs, which wastes CI time.

## 🛠️ Customization

### Modify the Hook

Edit the hook script:
```bash
vim .git/hooks/pre-commit
```

### Reinstall After Updates

If you update the `pre-commit` script in the repository:
```bash
./install-git-hooks.sh
```

### Uninstall

Remove the hook:
```bash
rm .git/hooks/pre-commit
```

## 🎨 Features

### Smart File Detection
- Only checks files that are staged for commit
- Automatically detects file types
- Skips checks if no relevant files are staged

### Graceful Degradation
- Checks which tools are installed
- Only runs checks for available tools
- Shows warnings for missing tools

### Colored Output
- 🟢 Green for success
- 🔴 Red for errors
- 🟡 Yellow for warnings
- 🔵 Blue for section headers

### Secret Detection
Basic check for potential secrets:
- Looks for patterns like `password="value"`
- Recommends using Ansible Vault
- Blocks commit if found

## 📊 Best Practices

1. **Install all linting tools** for full coverage
2. **Run the hook on every commit** (don't bypass)
3. **Fix issues immediately** while context is fresh
4. **Use Ansible Vault** for sensitive data
5. **Keep tools updated** for latest checks

## 🔄 Integration with CI/CD

The local pre-commit hook runs the **same checks** as GitHub Actions, so:
- ✅ If the hook passes, GitHub Actions should pass
- ⚡ Catch issues locally (faster feedback)
- 💰 Save CI minutes by preventing failed runs
- 🚀 Keep the main branch clean

## 🐛 Troubleshooting

### Hook not running
```bash
# Check if hook is executable
ls -l .git/hooks/pre-commit

# Make it executable
chmod +x .git/hooks/pre-commit
```

### Hook runs but tools not found
```bash
# Check if tools are in PATH
which ansible-lint yamllint shellcheck

# Install missing tools
pip install ansible-lint yamllint
brew install shellcheck  # or apt-get/snap
```

### Want to test without committing
```bash
# Run the hook manually
.git/hooks/pre-commit
```

### False positives
- Review the error carefully
- If legitimate, consider updating `.yamllint`, `.ansible-lint`, etc.
- As last resort: `git commit --no-verify`

## 📚 Related Documentation

- [Ansible Lint Rules](https://ansible-lint.readthedocs.io/rules/)
- [YAML Lint Rules](https://yamllint.readthedocs.io/en/stable/rules.html)
- [ShellCheck Wiki](https://github.com/koalaman/shellcheck/wiki)
- [Git Hooks Documentation](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)

## 💡 Tips

1. **Test incrementally**: Commit small changes more often
2. **Stage carefully**: Only stage files you've reviewed
3. **Read errors**: The hook output shows exactly what's wrong
4. **Learn from errors**: Each error is a learning opportunity
5. **Share knowledge**: Help teammates understand linting rules

---

**Installed the hook?** Great! Now every commit will be automatically checked for quality issues. Happy coding! 🎉

