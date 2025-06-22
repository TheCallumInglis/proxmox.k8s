# Proxmox K8s | Terraform

## Overview
Contains setup for self-hosted kubernetes infrastructure on Proxmox using Terraform.

## Reference  
- [Terraform | Proxmox Provider](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud-init%2520getting%2520started)
- [Terraform | Proxmox Provider | Cloud Init](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud_init)
- [Proxmox | Cloud-Init](https://pve.proxmox.com/wiki/Cloud-Init_Support)

## Setup | Proxmox
You must first configure the base image to be used as a template on Proxmox. Assuming you are running the following commands on the Proxmox host in the `/root` directory:

### Setup Cloud Image & Template VM

Refer to [scripts](/scripts/) directory for cloud init setup scripts:
  - [Debian 12](/scripts/debian12-cloudinit.sh)
  - [Ubuntu 24.04](/scripts/ubuntu2404-cloudinit.sh)

```bash
image="debian-12-genericcloud-amd64.qcow2"
template_vm="debian12-cloudinit"
template_vm_id="9000"
vm_disk="local-nvme"

wget https://cloud.debian.org/images/cloud/bookworm/latest/${image}

qm create ${template_vm_id} --name ${template_vm}
qm set ${template_vm_id} --scsi0 ${vm_disk}:0,import-from=/root/${image}
qm template ${template_vm_id}
```

### Setup Snippet for Cloud Init
- Updates System
- Installs QEMU Guest Agent
- Enables SSH Password Authentication

```bash
mkdir -p /var/lib/vz/snippets

tee /var/lib/vz/snippets/qemu-guest-agent.yml <<EOF
#cloud-config
runcmd:
  - apt-get update
  - apt-get upgrade -y
  - apt-get install -y qemu-guest-agent
  - systemctl start qemu-guest-agent
ssh_pwauth: True
EOF
```

## Usage
1. Configure `terraform.tfvars`
2. Run `terraform init`
3. Run `terraform apply`
