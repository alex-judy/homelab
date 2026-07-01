### 1Password configuration

variable "op_service_account_token" {
  description = "1Password Service Account Token"
  type        = string
  sensitive   = true
}

variable "op_vault_name" {
  description = "1Password vault name"
  type        = string
  default     = "Homelab"
}

### Proxmox provider configuration

variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API Token"
  type        = string
  sensitive   = true
}

variable "proxmox_username" {
  description = "Proxmox username"
  type        = string
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Skip TLS verification"
  type        = bool
  default     = true
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

### Global Proxmox defaults

variable "lxc_template" {
  description = "LXC template to use"
  type        = string
  default     = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
}

variable "lxc_storage" {
  description = "Storage pool for LXC containers"
  type        = string
  default     = "local-lvm"
}

variable "vm_storage" {
  description = "Storage pool for QEMU VMs"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}

variable "network_gateway" {
  description = "Network gateway"
  type        = string
  default     = "10.0.10.1"
}

variable "dns_servers" {
  description = "DNS servers"
  type        = string
  default     = "1.1.1.1,8.8.8.8"
}

variable "ssh_public_key" {
  description = "SSH public key for root access"
  type        = string
}

### Test resource defaults

variable "test_vm_name" {
  description = "Name for the test VM"
  type        = string
  default     = "terraform-ubuntu-vm"
}

variable "test_vm_id" {
  description = "VM ID for the test VM"
  type        = number
  default     = 4321
}

### LXC node definitions

variable "tailscale_lxc_name" {
  description = "Name for the Tailscale LXC"
  type        = string
  default     = "tailscale-lxc"
}

variable "tailscale_vmid" {
  description = "ID for the Tailscale LXC"
  type        = number
  default     = 100
}

variable "tailscale_ip" {
  description = "Static IP for Tailscale LXC"
  type        = string
  default     = "10.0.10.10"
}

variable "cloudflared_ip" {
  description = "Static IP for Cloudflared LXC"
  type        = string
  default     = "10.0.10.9"
}

variable "forgejo_vmid" {
  description = "Proxmox VMID for Forgejo LXC (set to existing VMID for import)"
  type        = number
  default     = 108
}

variable "forgejo_ip" {
  description = "Static IP for Forgejo LXC"
  type        = string
  default     = "10.0.10.18"
}

variable "beszel_vmid" {
  description = "Proxmox VMID for Beszel LXC (set to existing VMID for import)"
  type        = number
  default     = 116
}

variable "beszel_ip" {
  description = "Static IP for Beszel LXC"
  type        = string
  default     = "10.0.10.12"
}

variable "homeassistant_vmid" {
  description = "Proxmox VMID for Home Assistant LXC (set to existing VMID for import)"
  type        = number
  default     = 117
}

variable "homeassistant_ip" {
  description = "Static IP for Home Assistant LXC"
  type        = string
  default     = "10.0.10.15"
}

variable "plex_vmid" {
  description = "Proxmox VMID for Plex LXC (set to existing VMID for import)"
  type        = number
  default     = 113
}

variable "plex_ip" {
  description = "Static IP for Plex LXC"
  type        = string
  default     = "10.0.10.13"
}

variable "downloads_ip" {
  description = "Static IP for Downloads LXC"
  type        = string
  default     = "10.0.10.14"
}

variable "pterodactyl_panel_vmid" {
  description = "Proxmox VMID for Pterodactyl Panel LXC"
  type        = number
  default     = 118
}

### NFS and storage configuration

variable "truenas_nfs_server" {
  description = "TrueNAS NFS server IP"
  type        = string
  default     = "10.0.10.25"
}

variable "plex_nfs_export" {
  description = "NFS export path on the TrueNAS server for Plex"
  type        = string
  default     = "/mnt/primary/media"
}

variable "plex_nfs_mountpoint" {
  description = "Mount point inside the Plex LXC for the NFS export"
  type        = string
  default     = "/mnt/media"
}

### Ubuntu VM

variable "ubuntu_server_primary_vmid" {
  description = "Proxmox VMID for the Ubuntu server primary (Docker host)"
  type        = number
  default     = 101
}

variable "ubuntu_server_primary_ip" {
  description = "Static IP for Ubuntu server primary"
  type        = string
  default     = "10.0.10.20"
}

variable "ubuntu_server_primary_cores" {
  description = "vCPU count for Ubuntu server primary"
  type        = number
  default     = 8
}

variable "ubuntu_server_primary_memory" {
  description = "RAM (MB) for Ubuntu server primary"
  type        = number
  default     = 16000
}

variable "ubuntu_server_primary_disk" {
  description = "Disk size for Ubuntu server primary"
  type        = string
  default     = "378G"
}

variable "pterodactyl_panel_ip" {
  description = "Static IP for Pterodactyl Panel LXC"
  type        = string
  default     = "10.0.10.16"
}

### Ubuntu DevOps VM

variable "ubuntu_devops_server_primary_vmid" {
  description = "Proxmox VMID for the Ubuntu server primary (Docker host)"
  type        = number
  default     = 163
}

variable "ubuntu_devops_server_primary_ip" {
  description = "Static IP for Ubuntu DevOps server primary"
  type        = string
  default     = "10.0.10.60"
}

variable "ubuntu_devops_server_primary_cores" {
  description = "vCPU count for Ubuntu DevOps server primary"
  type        = number
  default     = 2
}

variable "ubuntu_devops_server_primary_memory" {
  description = "RAM (MB) for Ubuntu DevOps server primary"
  type        = number
  default     = 4096
}

variable "ubuntu_devops_server_primary_disk" {
  description = "Disk size for Ubuntu DevOps server primary"
  type        = number
  default     = 60
}

### Pterodactyl Wing VM configuration

variable "pterodactyl_wing_vmid" {
  description = "Proxmox VMID for Pterodactyl Wing virtual machine"
  type        = number
  default     = 119
}

variable "pterodactyl_wing_ip" {
  description = "Static IP for Pterodactyl Wing VM"
  type        = string
  default     = "10.0.10.17"
}

### Forgejo Runner configuration

variable "runner_public_key" {
  description = "Forgejo runner deploy public key"
  type        = string
}
