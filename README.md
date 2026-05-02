# Proxmox K8s Infrastructure

> **IaC Kubernetes homelab on Proxmox using Terraform & Ansible.**

[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)](#terraform)
[![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible&logoColor=white)](#ansible)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Cluster-326CE5?logo=kubernetes&logoColor=white)](#overview)
[![Proxmox](https://img.shields.io/badge/Proxmox-Virtualization-E57000?logo=proxmox&logoColor=white)](#overview)

![k8s-components](/assets/k8s-components.png)

---

## Overview

This repository defines a full **infrastructure-as-code workflow** for running Kubernetes on Proxmox:

- **`scripts/`**
Prepare Proxmox with cloud-init-ready VM templates.
- **`terraform/`**
Provision VM infrastructure on Proxmox.
- **`ansible/`**
Configure hosts, bootstrap Kubernetes, and install platform components.
- **`sample/`**
Example manifests for deploying workloads.

---

## Prerequisites

- Proxmox VE host with API access
- Terraform
- Ansible
- SSH keypair for VM access
- DNS/API tokens if using optional cert-manager automation

--- 

## Quick Start

### 1. Clone

```bash
git clone https://github.com/TheCallumInglis/proxmox.k8s.git
cd proxmox.k8s
```

### 2. Prepare Proxmox Template

Use one of the setup scripts in [scripts/](./scripts/) (e.g., Debian 12 / Ubuntu 24.04 cloud-init template).

### 3. Provision Infrastructure (Terraform)

```bash
cd terraform
# configure terraform.tfvars first
terraform init
terraform plan
terraform apply
```

### 4. Bootstrap Kubernetes (Ansible)

```bash
cd ansible
# configure inventory.ini + secrets files first
ansible-playbook -i inventory.ini playbook.yml
```

### 5. Deploy a Sample Workload

```bash
cd sample
kubectl apply -f ./hello-world/
```

---

## Terraform

See [terraform/README.md](./terraform/) for:

- provider and Proxmox setup
- cloud-init template requirements
- variable configuration and usage patterns

---

## Ansible

See [ansible/README.md](./ansible/) for:

- inventory format
- cluster bootstrap playbook
- optional playbooks:
  - kube user provisioning
  - cert-manager / DNS challenge integration


---

## Security Notes & Disclaimer

This is a homelab repo, but production-grade hygiene still matters. Never commit plaintext credentials or API keys. Use vaults or environment variables for secrets management. Always review and understand the code before running it, especially when it interacts with infrastructure.

This is a personal project, offered as-is without warranty. Use at your own risk, and always test in a safe environment before applying to critical systems.

---

## Operational Notes

- Current baseline targets single-control-plane + multi-worker
- Multi-master support is a planned future enhancement

--- 

## Roadmap

- Terraform:
    - [ ]  Re-instate [update_inventory.sh](/terraform/scripts/update_inventory.sh) script to update Ansible inventory with VM IPs.
- Ansible:
    - [ ] Harden host baseline (SSH/UFW/fail2ban)
    - [ ] Multi-Master K8s Cluster
    - [ ] Zabbix Monitoring
- Other:
    - [ ] Add CI checks (terraform fmt/validate, ansible-lint)
