# Quick Start Guide

This guide will help you get started with the storage server management repository in just a few minutes.

## 🚀 Quick Setup (5 minutes)

### 1. Install Dependencies

```bash
# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install required packages
pip install -r requirements.txt
```

### 2. Configure Your Inventory

Edit `inventory/hosts.ini` with your server details:

```ini
[storage_servers]
your-storage-01.example.com ansible_host=10.0.1.10

[monitoring_servers]
your-monitor-01.example.com ansible_host=10.0.2.10
```

### 3. Test Connection

```bash
ansible all -m ping -i inventory/hosts.ini
```

## 🎯 Common Tasks

### Provision a New Storage Server

```bash
ansible-playbook -i inventory/hosts.ini playbooks/provision_storage.yml
```

### Setup Monitoring

```bash
ansible-playbook -i inventory/hosts.ini playbooks/monitoring_setup.yml
```

### Check Syntax Before Running

```bash
ansible-playbook --syntax-check -i inventory/hosts.ini playbooks/provision_storage.yml
```

### Dry Run (No Changes)

```bash
ansible-playbook --check -i inventory/hosts.ini playbooks/provision_storage.yml
```

## 🔍 Linting Your Code

Before committing, run these checks:

```bash
# Lint Ansible files
ansible-lint playbooks/*.yml

# Lint YAML files
yamllint .

# Lint shell scripts
shellcheck scripts/**/*.sh
```

## 📊 GitHub Actions CI/CD

The repository includes three automated workflows:

1. **CI Workflow** (`.github/workflows/ci.yml`)
   - Runs on every push/PR
   - Lints Ansible, YAML, and shell scripts
   - Validates playbook syntax

2. **Security Workflow** (`.github/workflows/security.yml`)
   - Scans for vulnerabilities
   - Checks for hardcoded secrets
   - Runs weekly

3. **Test Workflow** (`.github/workflows/test.yml`)
   - Tests playbooks across multiple Ansible versions
   - Validates inventory files
   - Runs dry-run tests

## 🔧 Customizing Linting Rules

### Ansible Lint

Edit `.ansible-lint` to customize rules:

```yaml
skip_list:
  - yaml[line-length]  # Skip line length checks
```

### YAML Lint

Edit `.yamllint` to adjust formatting:

```yaml
rules:
  line-length:
    max: 200  # Increase line length limit
```

### Shell Check

Edit `.shellcheckrc` to disable specific checks:

```bash
disable=SC2086  # Disable quote warnings
```

## 🔒 Working with Secrets

Never commit secrets! Use Ansible Vault:

```bash
# Create encrypted file
ansible-vault create secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Use in playbook
ansible-playbook -i inventory/hosts.ini playbooks/your_playbook.yml --ask-vault-pass
```

## 📝 Creating New Playbooks

1. Create file in `playbooks/` directory
2. Follow this template:

```yaml
---
- name: Descriptive Playbook Name
  hosts: target_group
  become: true
  gather_facts: true

  tasks:
    - name: Task description
      ansible.builtin.module_name:
        parameter: value
```

3. Test syntax:
```bash
ansible-playbook --syntax-check playbooks/your_new_playbook.yml
```

4. Run lint:
```bash
ansible-lint playbooks/your_new_playbook.yml
```

## 🐛 Troubleshooting

### Connection Issues

```bash
# Test with verbose output
ansible all -m ping -i inventory/hosts.ini -vvv

# Check SSH manually
ssh ansible@your-server.example.com
```

### Linting Failures

```bash
# Get detailed output
ansible-lint -v playbooks/your_playbook.yml

# List all rules
ansible-lint -L
```

### Playbook Errors

```bash
# Run with maximum verbosity
ansible-playbook -vvvv -i inventory/hosts.ini playbooks/your_playbook.yml

# Check syntax first
ansible-playbook --syntax-check playbooks/your_playbook.yml
```

## 📚 Next Steps

- Read the full [README.md](README.md)
- Explore the [example playbooks](playbooks/)
- Review [monitoring scripts](scripts/monitoring/)
- Check [GitHub Actions workflows](.github/workflows/)

## 💡 Tips

1. **Always test with `--check` first** before running on production
2. **Use `--limit` to target specific hosts** for safer deployments
3. **Keep your inventory organized** by environment (dev, staging, prod)
4. **Use tags in playbooks** for running specific tasks
5. **Document your playbooks** with comments and task names

## 🤝 Getting Help

- Check the [README](README.md) for detailed documentation
- Review [Ansible documentation](https://docs.ansible.com/)
- Look at workflow files for CI/CD examples
- Test in a safe environment first!

---

Happy automating! 🎉

