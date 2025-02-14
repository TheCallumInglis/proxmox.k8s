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

resource "proxmox_vm_qemu" "WEBHOST01" {
  name        = "WEBHOST01"
  target_node = var.proxmox_host
  agent       = 1
  sockets     = 1
  cores       = 4
  memory      = 4096
  boot        = "order=scsi0" # has to be the same as the OS disk of the template
  clone       = var.template_name
  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot  = true

  os_type   = "cloud-init"
  cpu_type  = "host"

  # Cloud Init
  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml"
  ciupgrade  = true
  nameserver = "1.1.1.1"
  ipconfig0 = "ip=${var.public_ip}/${var.public_ip_mask},gw=${var.public_gw}"
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
          storage = "local"
          replicate = true
        }
      }  
      scsi1 {
        cloudinit {
          storage = "local"
        }
      }
    }
  }


  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
    macaddr = var.ovh_mac_address
  }

  connection {
    type        = "ssh"
    user        = var.vm_username
    password    = var.vm_password
    private_key = self.ssh_private_key
    host        = var.public_ip
    port        = 22
  }

  provisioner "remote-exec" {
    inline = [
      "ip a"
    ]
  }
}

output "public_ip" {
  value = "Assigned public IP: ${var.public_ip}"
}