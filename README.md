# Storage Server Management with Ansible

This repository contains Ansible playbooks, roles, and scripts for managing a suite of storage servers, including monitoring, alerting, reporting, and provisioning capabilities.

## 🚀 Features

- **Automated Provisioning**: Streamlined setup of new storage servers
- **Monitoring**: Real-time storage capacity and health monitoring
- **Alerting**: Multi-channel alert system (email, webhooks)
- **Reporting**: Automated daily/weekly storage reports
- **CI/CD Integration**: GitHub Actions workflows for linting and testing

## 📁 Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── ci.yml           # Main CI pipeline with linting
│       ├── security.yml     # Security scanning
│       └── test.yml         # Ansible playbook testing
├── inventory/
│   ├── hosts.ini           # Simple inventory file
│   └── production.yml      # Production inventory (YAML)
├── group_vars/
│   ├── all.yml             # Variables for all hosts
│   └── storage_servers.yml # Storage-specific variables
├── host_vars/              # Host-specific variables
├── playbooks/
│   ├── provision_storage.yml  # Storage provisioning playbook
│   └── monitoring_setup.yml   # Monitoring setup playbook
├── roles/                  # Ansible roles (add custom roles here)
├── scripts/
│   ├── monitoring/         # Monitoring scripts
│   ├── alerting/           # Alert scripts
│   ├── reporting/          # Report generation scripts
│   └── provisioning/       # Provisioning automation
├── .ansible-lint           # Ansible linting configuration
├── .yamllint               # YAML linting configuration
├── .shellcheckrc           # Shell script linting configuration
├── .banditrc               # Python security linting configuration
├── ansible.cfg             # Ansible configuration
├── requirements.txt        # Python dependencies
└── README.md               # This file
```

## 🛠️ Setup

### Prerequisites

- Python 3.8+
- Ansible 2.14+
- SSH access to target servers
- Git

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd <repository-name>
   ```

2. **Create a virtual environment:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure inventory:**
   Edit `inventory/hosts.ini` or `inventory/production.yml` with your server details:
   ```ini
   [storage_servers]
   storage-01.example.com ansible_host=10.0.1.10
   ```

5. **Test connectivity:**
   ```bash
   ansible all -m ping -i inventory/hosts.ini
   ```

## 📋 Usage

### Running Playbooks

**Provision a new storage server:**
```bash
ansible-playbook -i inventory/hosts.ini playbooks/provision_storage.yml
```

**Setup monitoring:**
```bash
ansible-playbook -i inventory/hosts.ini playbooks/monitoring_setup.yml
```

**Limit to specific hosts:**
```bash
ansible-playbook -i inventory/hosts.ini playbooks/provision_storage.yml --limit storage-01
```

**Dry run (check mode):**
```bash
ansible-playbook -i inventory/hosts.ini playbooks/provision_storage.yml --check
```

### Using Scripts

**Check storage capacity:**
```bash
./scripts/monitoring/check_storage.sh
```

**Generate storage report:**
```bash
./scripts/reporting/generate_storage_report.sh
```

**Provision new server:**
```bash
./scripts/provisioning/setup_new_storage.sh storage-04.example.com
```

## 🔍 Linting and Quality Checks

This repository includes comprehensive linting to ensure code quality:

### Manual Linting

**Lint Ansible files:**
```bash
ansible-lint playbooks/*.yml
```

**Lint YAML files:**
```bash
yamllint .
```

**Lint shell scripts:**
```bash
shellcheck scripts/**/*.sh
```

**Check Ansible syntax:**
```bash
ansible-playbook --syntax-check playbooks/provision_storage.yml
```

### Automated CI/CD

GitHub Actions automatically runs on every push and pull request:

- ✅ **Ansible Lint**: Checks Ansible best practices
- ✅ **YAML Lint**: Validates YAML syntax and formatting
- ✅ **ShellCheck**: Analyzes shell scripts for common issues
- ✅ **Syntax Check**: Validates Ansible playbook syntax
- ✅ **Security Scan**: Checks for vulnerabilities and secrets
- ✅ **Multi-version Testing**: Tests against multiple Ansible versions

## 🔒 Security

### Best Practices

1. **Never commit secrets** - Use Ansible Vault for sensitive data:
   ```bash
   ansible-vault encrypt group_vars/all.yml
   ```

2. **Use SSH keys** - Configure passwordless SSH authentication

3. **Regular updates** - Keep Ansible and dependencies updated:
   ```bash
   pip install --upgrade -r requirements.txt
   ```

4. **Security scanning** - The `security.yml` workflow runs automatically

### Ansible Vault

**Encrypt a file:**
```bash
ansible-vault encrypt secrets.yml
```

**Edit encrypted file:**
```bash
ansible-vault edit secrets.yml
```

**Run playbook with vault:**
```bash
ansible-playbook -i inventory/hosts.ini playbooks/provision_storage.yml --ask-vault-pass
```

## 🧪 Testing

**Syntax check all playbooks:**
```bash
find playbooks -name "*.yml" | xargs -I {} ansible-playbook --syntax-check {}
```

**Dry run on test servers:**
```bash
ansible-playbook -i inventory/hosts.ini playbooks/provision_storage.yml --check --diff
```

**Test with Molecule (for roles):**
```bash
cd roles/your_role
molecule test
```

## 📝 Customization

### Linting Rules

Customize linting rules by editing:
- `.ansible-lint` - Ansible linting rules
- `.yamllint` - YAML formatting rules
- `.shellcheckrc` - Shell script rules
- `.banditrc` - Python security rules

### Variables

- **Global variables**: Edit `group_vars/all.yml`
- **Group-specific**: Edit `group_vars/<group_name>.yml`
- **Host-specific**: Create `host_vars/<hostname>.yml`

### Adding New Playbooks

1. Create playbook in `playbooks/` directory
2. Follow naming convention: `verb_noun.yml` (e.g., `deploy_application.yml`)
3. Include proper documentation in comments
4. Test locally before committing

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Ensure all linting passes locally
4. Submit a pull request
5. Wait for CI/CD checks to pass

## 📊 Monitoring & Alerting

### Storage Monitoring

- Automatic checks every 15 minutes
- Warning threshold: 80% capacity
- Critical threshold: 90% capacity
- Logs: `/var/log/storage_monitor.log`

### Alerts

Alerts are sent via:
- Email: Configured in `send_alert.sh`
- Webhooks: For integration with Slack, PagerDuty, etc.

## 🐛 Troubleshooting

**Connection issues:**
```bash
ansible all -m ping -i inventory/hosts.ini -vvv
```

**Linting errors:**
```bash
# Show detailed ansible-lint output
ansible-lint -v playbooks/your_playbook.yml
```

**Playbook failures:**
```bash
# Run with maximum verbosity
ansible-playbook -i inventory/hosts.ini playbooks/your_playbook.yml -vvvv
```

## 📚 Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [ansible-lint Rules](https://ansible-lint.readthedocs.io/)
- [YAML Lint](https://yamllint.readthedocs.io/)

## 📄 License

[Specify your license here]

## 👥 Authors

[Your name/team here]

---

**Last Updated:** October 2025

