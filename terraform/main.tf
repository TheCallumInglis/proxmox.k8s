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

resource "proxmox_vm_qemu" "k8s_node" {
  for_each    = { for i in range(1, var.vm_count + 1) : i => "K8s-VM-${i}" }
  name        = each.value
  target_node = var.proxmox_host
  agent       = 1
  sockets     = 1
  cores       = 4
  memory      = 6144
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
  nameserver = "1.1.1.1"
  ipconfig0  = var.dhcp_ip ? "ip=dhcp" : "ip=${var.public_ip}/${var.public_ip_mask},gw=${var.public_gw}" # TODO Adjust for Multiple IPs
  skip_ipv6  = true
  ciuser     = var.vm_username
  cipassword = var.vm_password
  sshkeys    = <<EOT
${var.ssh_public_key}
EOT

  # Most cloud-init images require a serial device for their display
  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "40G"
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
    bridge = var.bridge
    model  = "virtio"
    macaddr = var.ovh_mac_address != "" ? var.ovh_mac_address : null

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