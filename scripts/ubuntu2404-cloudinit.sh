#!/bin/bash
# Run on Proxmox Host

image="noble-server-cloudimg-amd64.img"
template_vm="ubuntu2404-cloudinit"
template_vm_id="9001"
vm_disk="local-nvme"

wget https://cloud-images.ubuntu.com/noble/current/${image}

qm create ${template_vm_id} --name ${template_vm}
qm set ${template_vm_id} --scsi0 ${vm_disk}:0,import-from=/root/${image}
qm template ${template_vm_id}
