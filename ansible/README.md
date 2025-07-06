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

## Optional: Kube Users

## Setup | Secrets
Create `kubeusers.secrets.yml` with the following structure:
```yaml
kube_users:
    - user1
    - user2
```

Run the playbook::
```bash
ansible-playbook -i inventory.ini kubeusers.yml
```

Test the user:
```bash
KUBECONFIG=kubeconfigs/user1.yaml kubectl get pods -A
# Expect: "Error from server (Forbidden): pods is forbidden: User "user1" cannot list resource "pods" in API group "" at the cluster scope"
```

Optional, setup roles for the users:
```bash
# e.g. give cluster-admin role to user1
kubectl create clusterrolebinding user1-admin --clusterrole=cluster-admin --user=user1
```