output "vm_ips" {
  description = "IP addresses of VMs"
  value = {
    ubuntu_server_primary = var.ubuntu_server_primary_ip
    pterodactyl_wing      = var.pterodactyl_wing_ip
  }
}

output "vm_vmids" {
  description = "Proxmox VMIDs for QEMU VMs"
  value = {
    ubuntu_server_primary = var.ubuntu_server_primary_vmid
    pterodactyl_wing      = var.pterodactyl_wing_vmid
  }
}
