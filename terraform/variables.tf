variable "proxmox_api_url" { default = "https://proxmox.example.com:8006/api2/json" }
variable "proxmox_host" { default = "proxmox-node1" }

variable "template_name" { default = "debian12-cloudinit" }
variable "template_storage" { default = "local-nvme" }
variable "vm_storage" { default = "local-nvme" }

variable "proxmox_username" {} // user@realm
variable "proxmox_password" {}

variable "vm_count" { default = 3 }
variable "vm_username" {}
variable "vm_password" {}
variable "ssh_public_key" {}

variable "k8s_master" {
    type = object({
        ip_addr    = string
        ip_mask    = string
        ip_gw      = string
        nameserver = string

        mac     = string
        bridge  = string

        cpu     = number
        memory  = number
    })
    default = {
        ip_addr    = "10.2.10.10"
        ip_mask    = "24"
        ip_gw      = "10.2.10.1"
        nameserver = "1.1.1.1"

        mac     = ""
        bridge  = "vmbr0"

        cpu     = 2
        memory  = 2048
    }
}

variable "k8s_nodes" {
    type = object({
        count = number

        first_ip   = number # Last octet of the first IP address, used for dynamic assignment
        ip_addr    = string # Leave last octet for dynamic assignment
        ip_mask    = string
        ip_gw      = string
        nameserver = string

        bridge  = string

        cpu     = number
        memory  = number
    })
    default = {
        count = 3

        first_ip   = 11
        ip_addr    = "10.2.10" 
        ip_mask    = "24"
        ip_gw      = "10.2.10.1"
        nameserver = "1.1.1.1"

        bridge = "vmbr0"

        cpu    = 2
        memory = 6144
    }
}