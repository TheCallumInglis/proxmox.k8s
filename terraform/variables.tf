variable "proxmox_api_url" { default = "https://proxmox.example.com:8006/api2/json" }
variable "proxmox_host" { default = "proxmox-node1" }

variable "template_name" { default = "debian12-cloudinit" }

variable "proxmox_username" {} // user@realm
variable "proxmox_password" {}

variable "vm_username" {}
variable "vm_password" {}
variable "ssh_public_key" {}

variable "public_ip" { default = "10.0.2.99"}
variable "public_ip_mask" { default = "24"}
variable "public_gw" { default = "10.0.2.254"}
variable "ovh_mac_address" {}