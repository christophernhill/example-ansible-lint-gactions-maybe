# Linting Rules and Configuration

This document explains the linting rules configured for this repository and how to customize them.

## 📋 Overview

This repository uses multiple linting tools to ensure code quality:

| Tool | Purpose | Config File | Runs On |
|------|---------|-------------|---------|
| **ansible-lint** | Ansible best practices | `.ansible-lint` | `.yml` playbooks/roles |
| **yamllint** | YAML syntax/formatting | `.yamllint` | All `.yml`/`.yaml` files |
| **shellcheck** | Shell script analysis | `.shellcheckrc` | All `.sh` files |
| **bandit** | Python security | `.banditrc` | All `.py` files |
| **checkov** | IaC security | (defaults) | Ansible files |

## 🔧 Ansible Lint (`.ansible-lint`)

### Current Configuration

```yaml
exclude_paths:
  - .cache/
  - .github/
  - test_inventory/
  - venv/

loop_var_prefix: "{role}_"
var_naming_pattern: "^[a-z_][a-z0-9_]*$"
```

### Key Rules Enforced

1. **Variable Naming**: Variables must be lowercase with underscores
2. **Loop Variables**: Must be prefixed with role name (in roles)
3. **No Log Password**: Sensitive tasks must use `no_log: true`
4. **Module Names**: Must use FQCN (e.g., `ansible.builtin.copy`)

### Common Rules You Might Want to Skip

Add to `skip_list` in `.ansible-lint`:

```yaml
skip_list:
  - yaml[line-length]         # Long lines
  - name[casing]              # Task name casing
  - fqcn[action-core]         # Fully qualified collection names
  - schema[meta]              # Meta schema validation
  - no-changed-when           # Missing changed_when
  - no-handler                # Tasks that look like handlers
```

### Testing Locally

```bash
# Lint all playbooks
ansible-lint playbooks/

# Lint specific file
ansible-lint playbooks/provision_storage.yml

# Show all rules
ansible-lint -L

# Verbose output
ansible-lint -v playbooks/provision_storage.yml
```

## 📝 YAML Lint (`.yamllint`)

### Current Configuration

```yaml
rules:
  line-length:
    max: 160
    level: warning
  
  indentation:
    spaces: 2
    indent-sequences: true
  
  truthy:
    allowed-values: ['true', 'false', 'yes', 'no']
```

### Key Rules Enforced

1. **Line Length**: Maximum 160 characters (warning)
2. **Indentation**: 2 spaces, with sequence indentation
3. **Truthy Values**: Only allow specific boolean values
4. **Document Start**: Require `---` at file start

### Customization Examples

```yaml
# Increase line length
rules:
  line-length:
    max: 200

# Disable truthy checks for keys
rules:
  truthy:
    check-keys: false

# Disable specific rules
rules:
  comments-indentation: disable
```

### Testing Locally

```bash
# Lint all YAML files
yamllint .

# Lint specific file
yamllint inventory/production.yml

# Show configuration
yamllint -d display .yamllint
```

## 🐚 ShellCheck (`.shellcheckrc`)

### Current Configuration

```bash
enable=all
disable=SC1091  # Not following sourced files
shell=bash
```

### Key Rules Enforced

1. **Quoting**: Proper quoting of variables
2. **Exit Codes**: Checking command results
3. **Portability**: Bash-specific features flagged
4. **Best Practices**: Following shell scripting best practices

### Common Rules You Might Want to Disable

Add to `.shellcheckrc`:

```bash
# Disable specific checks
disable=SC1091  # Not following sourced files
disable=SC2086  # Double quote to prevent globbing
disable=SC2155  # Declare and assign separately
disable=SC2034  # Unused variables
```

### ShellCheck Error Codes

| Code | Description | Severity |
|------|-------------|----------|
| SC1091 | Not following sourced files | Info |
| SC2086 | Unquoted variable expansion | Warning |
| SC2155 | Declare and assign separately | Warning |
| SC2034 | Unused variable | Warning |
| SC2046 | Quote to prevent word splitting | Warning |

### Testing Locally

```bash
# Check all shell scripts
shellcheck scripts/**/*.sh

# Check specific file
shellcheck scripts/monitoring/check_storage.sh

# Output format as JSON
shellcheck -f json scripts/monitoring/check_storage.sh

# Ignore specific check
shellcheck -e SC2086 scripts/monitoring/check_storage.sh
```

## 🔒 Bandit (`.banditrc`)

### Current Configuration

```ini
[bandit]
exclude_dirs = ['/test', '/.venv', '/venv']
level = low
confidence = low
```

### Key Security Checks

1. **Hardcoded Passwords**: Detects potential passwords in code
2. **SQL Injection**: Flags SQL string concatenation
3. **Shell Injection**: Warns about command injection risks
4. **Weak Crypto**: Identifies weak cryptographic methods

### Testing Locally

```bash
# Scan all Python files
bandit -r .

# Scan specific file
bandit scripts/example.py

# Generate report
bandit -r . -f html -o bandit-report.html
```

## ✅ GitHub Actions Integration

### CI Workflow

The CI workflow runs all linters on every push/PR:

```yaml
- ansible-lint playbooks/
- yamllint .
- shellcheck scripts/**/*.sh
- ansible-playbook --syntax-check playbooks/*.yml
```

### Passing CI Checks

To ensure your code passes CI:

```bash
# Run all checks locally
ansible-lint playbooks/
yamllint .
shellcheck scripts/**/*.sh
find playbooks -name "*.yml" -exec ansible-playbook --syntax-check {} \;
```

### Bypassing Specific Checks

**In Ansible files** - Add comment:
```yaml
- name: This task is exempt
  command: some_command  # noqa: command-instead-of-module
```

**In Shell scripts** - Add directive:
```bash
# shellcheck disable=SC2086
echo $VARIABLE
```

**In YAML files** - Add comment:
```yaml
# yamllint disable-line rule:line-length
very_long_line: "This line is exempt from line length checks"
```

## 🎯 Pre-commit Hooks (Optional)

You can add pre-commit hooks to run linting before commits:

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
echo "Running linters..."

# Lint Ansible
ansible-lint playbooks/ || exit 1

# Lint YAML
yamllint . || exit 1

# Lint shell scripts
find scripts -name "*.sh" -exec shellcheck {} \; || exit 1

echo "All linters passed!"
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

## 📊 Linting Best Practices

### 1. Run Linters Locally First
Always run linters before pushing:
```bash
make lint  # If using Makefile
# or
ansible-lint && yamllint . && shellcheck scripts/**/*.sh
```

### 2. Fix Issues Incrementally
Don't try to fix everything at once:
```bash
# Fix one file at a time
ansible-lint playbooks/provision_storage.yml
# Fix issues
ansible-lint playbooks/provision_storage.yml  # Verify
```

### 3. Understand the Rules
Before disabling a rule, understand why it exists:
```bash
# See rule documentation
ansible-lint -L | grep rule-name
```

### 4. Use Consistent Style
Follow the configured style consistently across all files.

### 5. Document Exceptions
When you must disable a rule, add a comment explaining why:
```yaml
# Disabling line-length because this is a complex command that can't be split
- name: Run complex command  # noqa: yaml[line-length]
  command: very_long_command_here
```

## 🔄 Updating Linting Rules

### When to Update Rules

- Starting a new project phase
- After team discussion
- When rules are too strict/lenient
- To align with new best practices

### How to Update

1. Edit the config file (`.ansible-lint`, `.yamllint`, etc.)
2. Test locally on several files
3. Commit the config change
4. Update team documentation

### Example: Relaxing Line Length

```yaml
# .yamllint
rules:
  line-length:
    max: 200  # Increased from 160
    level: warning  # Changed from error
```

## 🆘 Troubleshooting

### False Positives

If a linter reports a false positive:
1. Add inline exception with comment
2. Consider if the rule should be adjusted
3. Document why it's a false positive

### Performance Issues

If linting is slow:
1. Exclude unnecessary directories
2. Use specific paths instead of recursive
3. Run linters in parallel

### Conflicting Rules

If rules conflict:
1. Check documentation for both tools
2. Prioritize Ansible-specific rules
3. Adjust the less critical rule

## 📚 Resources

- [ansible-lint Documentation](https://ansible-lint.readthedocs.io/)
- [yamllint Documentation](https://yamllint.readthedocs.io/)
- [ShellCheck Wiki](https://github.com/koalaman/shellcheck/wiki)
- [Bandit Documentation](https://bandit.readthedocs.io/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

---

**Remember**: Linting tools are helpers, not dictators. Use them to improve code quality, but don't let them block productivity unnecessarily.

