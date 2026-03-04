resource "proxmox_virtual_environment_container" "pterodactyl_panel" {
  vm_id     = var.pterodactyl_panel_vmid
  node_name = var.proxmox_node

  operating_system {
    template_file_id = var.lxc_template
    type             = "ubuntu"
  }

  disk {
    datastore_id = var.lxc_storage
    size         = 5
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }

  network_interface {
    name   = "eth0"
    bridge = var.network_bridge
  }

  initialization {
    hostname = "pterodactyl-panel"

    ip_config {
      ipv4 {
        address = "${var.pterodactyl_panel_ip}/24"
        gateway = var.network_gateway
      }
    }

    dns {
      servers = split(",", var.dns_servers)
    }

    user_account {
      keys     = [var.ssh_public_key]
      password = onepassword_item.pterodactyl_panel_lxc.password
    }
  }

  startup {
    order = 1
  }

  lifecycle {
    ignore_changes = [
      description,
      initialization,
    ]
  }
}
