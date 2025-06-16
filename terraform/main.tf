terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_username
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "k8s_master" {
  count       = 1
  name        = "K8s-VM-Master"
  target_node = var.proxmox_host
  agent       = 1
  sockets     = 1
  cores       = var.k8s_master.cpu
  memory      = var.k8s_master.memory
  boot        = "order=scsi0" # has to be the same as the OS disk of the template

  clone       = var.template_name
  clone_wait  = 10

  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot  = true

  os_type   = "cloud-init"
  cpu_type  = "host"

  # Cloud Init
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml"
  ciupgrade  = true
  nameserver = var.k8s_master.nameserver
  ipconfig0  = "ip=${var.k8s_master.ip_addr}/${var.k8s_master.ip_mask},gw=${var.k8s_master.ip_gw}"
  skip_ipv6  = true
  ciuser     = var.vm_username
  cipassword = var.vm_password
  sshkeys    = <<EOT
${var.ssh_public_key}
EOT

  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "32G"
          storage = "${var.vm_storage}"
          replicate = true
        }
      }  
      scsi1 {
        cloudinit {
          storage = "${var.template_storage}"
        }
      }
    }
  }


  network {
    id     = 0
    model  = "virtio"
    macaddr = var.k8s_master.mac != "" ? var.k8s_master.mac : null
    bridge = var.k8s_master.bridge
  }

}

resource "proxmox_vm_qemu" "k8s_node" {
  count       = var.k8s_nodes.count
  name        = "K8s-VM-Node-${count.index + 1}"
  target_node = var.proxmox_host
  agent       = 1
  sockets     = 1
  cores       = var.k8s_nodes.cpu
  memory      = var.k8s_nodes.memory
  boot        = "order=scsi0"

  clone       = var.template_name
  clone_wait  = 10

  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot  = true

  os_type   = "cloud-init"
  cpu_type  = "host"

  # Cloud Init
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml"
  ciupgrade  = true
  nameserver = var.k8s_nodes.nameserver
  ipconfig0  = "ip=${var.k8s_nodes.ip_addr}.${var.k8s_nodes.first_ip + count.index}/${var.k8s_nodes.ip_mask},gw=${var.k8s_nodes.ip_gw}"
  skip_ipv6  = true
  ciuser     = var.vm_username
  cipassword = var.vm_password
  sshkeys    = <<EOT
${var.ssh_public_key}
EOT

  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "32G"
          storage = "${var.vm_storage}"
          replicate = true
        }
      }  
      scsi1 {
        cloudinit {
          storage = "${var.template_storage}"
        }
      }
    }
  }


  network {
    id     = 0
    model  = "virtio"
    bridge = var.k8s_nodes.bridge
  }

#   connection {
#     type        = "ssh"
#     user        = var.vm_username
#     password    = var.vm_password
#     private_key = self.ssh_private_key
#     host        = var.public_ip
#     port        = 22
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "ip a"
#     ]
#   }
}

# resource "null_resource" "update_inventory" {
#   depends_on = [proxmox_vm_qemu.k8s_node]

#   provisioner "local-exec" {
#     command = "bash ./scripts/update_inventory.sh"
#   }
# }