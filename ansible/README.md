# Proxmox K8s | Ansible

## Overview
Contains setup for basic multi-node, single-master Kubernetes cluster using Ansible, targeting Ubuntu 24.04 LTS VMs.

Secures instance & sets up common tooling, including:
- curl, htop, vim, ufw, etc...
- ~~UFW, Fail2ban, Disable Root Login~~ (TODO)
- Containerd, Kubernetes, kubeadm, kubelet, kubectl
- Bootstraps Kubernetes cluster with:
    - Single Master Node
    - Multiple Worker Nodes
- Configures:
    - CNI (Container Network Interface) plugin (Calico)
    - Load Balancer (MetalLB)
    - Istio Service Mesh

## Setup | Inventory
Define `inventory.ini`, for example:

```ini
[K8s_Master]
x.x.x.x ansible_user=username ansible_ssh_private_key_file=~/.ssh/id_rsa

[K8s_Workers]
x.x.x.x ansible_user=username ansible_ssh_private_key_file=~/.ssh/id_rsa

[all:vars]

ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

## Usage  
```bash
ansible-playbook -i inventory.ini playbook.yml
```