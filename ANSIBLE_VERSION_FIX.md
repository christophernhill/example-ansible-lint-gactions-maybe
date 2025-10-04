# Ansible Version Fix

## Problem

The GitHub Actions workflow was failing with:
```
ERROR: Could not find a version that satisfies the requirement ansible==2.15
```

## Root Cause

The issue was that we were trying to install `ansible==2.15`, but:
- Ansible 2.x refers to the old `ansible-core` versions
- Starting with Ansible 2.10+, the versioning changed:
  - The `ansible` package is now a collection of modules + ansible-core
  - `ansible-core` contains the core engine

## Version Mapping

| ansible Package | ansible-core Version |
|----------------|---------------------|
| ansible 7.x    | ansible-core 2.14   |
| ansible 8.x    | ansible-core 2.15   |
| ansible 9.x    | ansible-core 2.16   |
| ansible 10.x   | ansible-core 2.17   |

## Changes Made

### 1. Updated `requirements.txt`

**Before:**
```python
ansible>=2.14,<2.17
ansible-core>=2.14,<2.17
```

**After:**
```python
# Use the full ansible package (version 8.x+ includes ansible-core 2.15+)
ansible>=8.0.0
```

### 2. Updated `.github/workflows/test.yml`

**Before:**
```yaml
matrix:
  ansible_version: ['2.14', '2.15', '2.16']
# ...
pip install "ansible==${{ matrix.ansible_version }}"
```

**After:**
```yaml
matrix:
  # ansible 7.x = ansible-core 2.14
  # ansible 8.x = ansible-core 2.15
  # ansible 9.x = ansible-core 2.16
  ansible_version: ['7', '8', '9']
# ...
pip install "ansible~=${{ matrix.ansible_version }}.0"
```

## Result

The GitHub Actions workflows should now:
- ✅ Install valid ansible package versions
- ✅ Test across ansible 7.x, 8.x, and 9.x
- ✅ Run linting successfully
- ✅ Complete without version errors

## Resources

- [Ansible Release and Maintenance](https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html)
- [Ansible Package vs ansible-core](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#selecting-an-ansible-package-and-version-to-install)
