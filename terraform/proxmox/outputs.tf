output "lxc_ips" {
  description = "IP addresses of all LXC containers"
  value = {
    tailscale         = var.tailscale_ip
    forgejo           = var.forgejo_ip
    beszel            = var.beszel_ip
    plex              = var.plex_ip
    pterodactyl_panel = var.pterodactyl_panel_ip
  }
}

output "lxc_vmids" {
  description = "Proxmox VMIDs for LXC containers"
  value = {
    plex              = proxmox_virtual_environment_container.plex.id
    tailscale         = proxmox_virtual_environment_container.tailscale.id
    forgejo           = proxmox_virtual_environment_container.forgejo.id
    beszel            = proxmox_virtual_environment_container.beszel.id
    pterodactyl_panel = proxmox_virtual_environment_container.pterodactyl_panel.id
  }
}
