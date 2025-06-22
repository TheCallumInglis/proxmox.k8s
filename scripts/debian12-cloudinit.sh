#!/bin/bash
# Run on Proxmox Host

image="debian-12-genericcloud-amd64.qcow2"
template_vm="debian12-cloudinit"
template_vm_id="9000"
vm_disk="local-nvme"

wget https://cloud.debian.org/images/cloud/bookworm/latest/${image}

qm create ${template_vm_id} --name ${template_vm}
qm set ${template_vm_id} --scsi0 ${vm_disk}:0,import-from=/root/${image}
qm template ${template_vm_id}