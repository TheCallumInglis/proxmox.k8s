# Proxmox K8s Infrastructure

Forked from [TheCallumInglis/hosting.infra](https://github.com/TheCallumInglis/hosting.infra) on 2025-06-15.

## Overview

This repository provides an Infrastructure as Code (IaC) setup for deploying and managing a kubernetes cluster on Proxmox, using: 
- Terraform
    - Automates VM provisioning in Proxmox.
- Ansible
    - Configures the VM with K8s and sets up cluster components.

## Setup
### 1. Clone the Repository
```bash
git clone https://github.com/TheCallumInglis/proxmox.k8s.git
cd proxmox.k8s
```

### 2. Configure & Run Terraform
See [Terraform](./terraform/) docs!

This will:  
> ✅ Provision a Debian VM in Proxmox  
> ✅ Assign a public IP  
> ✅ Automatically generate the Ansible inventory file  

<!-- ### 3. Configure & Run Ansible
See [Ansible](./ansible/) docs!

This will:  
> ✅ Update the system & install Docker  
> ✅ Deploy Nginx Proxy Manager  
> ✅ Install & configure the Zabbix agent   -->

<!-- ## Usage
### Nginx Proxy Manager
1. Access Nginx Proxy Manager at http://your-vm-ip:81
2. Default login:
    - Email: admin@example.com
    - Password: changeme

**NOTE: Ansible will not add a UFW rule for port 81**

### Portainer (Docker Management)
1. Access Portainer at:  
   **`http://your-vm-ip:9443`**
2. On the first login:
   - Create an **admin user**
   - Choose **Local Environment** (to manage Docker on this VM)
3. Use Portainer to:
   - Deploy, update, or remove containers
   - View logs & monitor resource usage
   - Set up container networking

**NOTE: Ansible will not add a UFW rule for port 9443**

### WireGuard VPN
- WireGuard runs as a **Docker container**.
- The **default subnet** for clients: `10.66.0.0/24`
- The **host** is accessible on `10.66.0.1`
- **Server port:** `51820`

#### Client Configuration
To get the client config, run:
```sh
docker exec -it wireguard cat /config/peer1/peer1.conf
# or
docker logs -f wireguard # includes QR-code
```

This file can be imported into the WireGuard app on your device.

### Zabbix Monitoring
- Ensure the Zabbix server can communicate with the agent.
- Check logs in /var/log/zabbix-agent/zabbix_agentd.log. -->

<!-- ## Security
 - SSH Root Login Disabled
 - UFW Firewall Configured (ports 22, 80, 443, 10050)
- Fail2Ban Installed
- Zabbix Agent Uses PSK Encryption
- Secrets Are Not Stored in the Repo

## Future Improvements
- Automate MySQL & PostgreSQL setup.
- Automate backups for Nginx & MySQL. -->