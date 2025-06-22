# Proxmox K8s Infrastructure

Forked from [TheCallumInglis/hosting.infra](https://github.com/TheCallumInglis/hosting.infra) on 2025-06-15.

![k8s-components](/assets/k8s-components.png)

## Overview

This repository provides an Infrastructure as Code (IaC) setup for deploying and managing a kubernetes cluster on Proxmox, using: 
- [Scripts](./scripts/)
    - Prepares Proxmox with a cloud-init enabled template.
- [Terraform](./terraform/)
    - Automates VM provisioning in Proxmox, using aforementioned template.
- [Ansible](./ansible/)
    - Configures the VM with K8s and sets up cluster components.
- [Sample](./sample/)
    - Example manifests for deploying applications on the cluster.

## Setup
### 1. Clone the Repository
```bash
git clone https://github.com/TheCallumInglis/proxmox.k8s.git
cd proxmox.k8s
```

### 2. Configure & Run Terraform
See [Terraform](./terraform/) docs!

### 3. Configure & Run Ansible
See [Ansible](./ansible/) docs!

### 4. Deploy Sample Applications
See [Sample](./sample) directory for an example manifest to deploy applications on the cluster.

## Future Improvements
- Terraform Enhancements:
    - [ ] Re-instate [update_inventory.sh](/terraform/scripts/update_inventory.sh) script to update Ansible inventory with VM IPs.

- Ansible Playbook Enhancements:
    - [ ] Securty Hardening
    - [ ] Zabbix Monitoring

- Automate setup of:
    - [ ] SSL Certificate Issuance
    - [ ] Multi-Master K8s Cluster