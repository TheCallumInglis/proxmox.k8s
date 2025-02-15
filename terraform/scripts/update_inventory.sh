#!/bin/bash

# Get public IP from Terraform output
VM_IP=$(terraform output -raw vm_public_ip)
VM_USER=$(terraform output -raw vm_user)

INVENTORY_FILE="../ansible/inventory.ini"

# Generate inventory.ini dynamically
cat <<EOF > $INVENTORY_FILE
[webserver]
$VM_IP ansible_user=$VM_USER ansible_ssh_private_key_file=~/.ssh/id_rsa
EOF

echo "Inventory file updated: $INVENTORY_FILE"