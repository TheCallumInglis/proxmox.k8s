# Hosting Infrastructure | Ansible

## Overview
Contains setup for basic web hosting infrastructure using Ansible.

Secures instance & sets up common tooling, including:
- curl, htop, vim, ufw, etc...
- UFW, Fail2ban, Disable Root Login
- Docker
- Nginx Reverse Proxy Manager
- Zabbix

## Setup | Inventory
If using [Terraform](../terraform/) to provision the host, `inventory.ini` will be automatically populated with the host details.

Otherwise, you'll need to define `inventory.ini` manually, for example:

```ini
[webserver]
0.0.0.0 ansible_user=username ansible_ssh_private_key_file=~/.ssh/id_rsa
```

## Setup | Secrets
The playbook requires secrets to be defined in `secrets.yml`

`secrets.example.yml` has been provided for reference.

## Usage  
```bash
ansible-playbook -i inventory.ini playbook.yml
```