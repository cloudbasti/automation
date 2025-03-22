# Ansible Commands Guide

## Basic Ansible Commands

### Testing Connection to Ansible Hosts
```bash
# Verify connectivity to all hosts in inventory
ansible -i inventory.yml all -m ping
```

### Running Ansible Playbooks
```bash
# Launch a playbook using specific inventory (from inside ansible folder)
ansible-playbook -i inventories/inventory.yml playbooks/k8s-master.yml
```

### Ad-hoc Commands
```bash
# Run shell command on all hosts
ansible -i inventory.yml all -m shell -a "uptime"

# Install package on all hosts
ansible -i inventory.yml all -m apt -a "name=nginx state=present" -b

# Copy file to hosts
ansible -i inventory.yml all -m copy -a "src=/local/path dest=/remote/path"
```

### Ansible Dry Run (Check Mode)
```bash
# Test a playbook without making changes
ansible-playbook -i inventory.yml playbook.yml --check
```

### Display Host Information
```bash
# Gather and display facts about hosts
ansible -i inventory.yml all -m setup
```

## Ansible Linting

### Linting Ansible Files
```bash
# Install ansible-lint
sudo apt-get install ansible-lint

# Lint an Ansible file
ansible-lint filename.yml

# Lint the current file in Vim
:!ansible-lint -f pep8 %
```
